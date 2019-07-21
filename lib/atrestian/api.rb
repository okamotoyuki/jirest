require 'open-uri'
require 'nokogiri'
require 'digest/sha2'

module Atrestian

  API_DOC_URI = 'https://developer.atlassian.com/cloud/jira/platform/rest/v3'

  # A class which stands REST API information
  class ApiInfo

    attr_reader :name, :params, :command, :digest

    def initialize(name, params, command, digest=nil)
      @name = name
      @params = params
      @command = command
      @digest = digest || calc_digest
    end

    private def calc_digest
      str = @name
      @params.each do |param|
        str += param[0] # param name
      end
      str += @command
      return Digest::SHA256.hexdigest(str)
    end

  end

  class ApiInfoTable

    def initialize(config=nil)
      @hash = {}
      load_config(config) unless config.nil?
    end

    def set(name, api_info)
      @hash[name] = api_info
    end

    def get(name)
      return @hash[name]
    end

    def size
      return @hash.size
    end

    def each
      if block_given?
        @hash.each do |key, value|
          yield(key, value)
        end
      end
    end

    def dump_config
      config = {}
      @hash.each do |key, value|
        api = {}
        api['name'] = value.name
        api['params'] = value.params
        api['command'] = value.command
        api['digest'] = value.digest
        config[key] = api
      end
      return config
    end

    private def load_config(config)
      config.each do |key, value|
        @hash[key] = ApiInfo.new(value['name'], value['params'], value['command'], value['digest'])
      end
    end

  end

  # A class which is for updating REST API information
  class ApiInfoUpdater

    def initialize()
      @current_apis = ApiInfoTable.new(Util::load_api_config)
      @latest_apis = get_latest_apis
    end

    private def get_latest_apis
      latest_apis = ApiInfoTable.new

      charset = nil
      html = open(API_DOC_URI) do |f|
        charset = f.charset
        f.read
      end

      doc = Nokogiri::HTML.parse(html, nil, charset)
      doc.css('h3').each do |h3|
        # check if the 'h3' tag is about REST API information
        if not h3.attribute('id').value.start_with?('api-rest-api')
          next
        end

        name = h3.content
        root_api_elem = h3.parent

        # extract parameters
        params = []
        h5_arr = root_api_elem.css('div > h5')
        if not h5_arr.empty? and h5_arr.first.content == 'Query parameters'
          section_arr = h5_arr.first.parent.css('section')
          unless section_arr.empty?
            section_arr.each do |section|
              param_info = Array.new(4)
              section.children.each_with_index do |child, i|
                param_info[i] = child.content
              end
              params.push(param_info)
            end
          end
        end

        # extract 'curl' command
        command = nil
        root_api_elem.css('h4').each do |h4|
          if h4.content == 'Example'
            div = h4.next
            code_arr = div.css('code')
            if not code_arr.empty?
              command = code_arr.last.content
            end
          end
        end
        next if command.nil?

        latest_apis.set(name, ApiInfo.new(name, params, command))
      end

      return latest_apis
    end

    # check if any API is changed on the API reference
    private def is_api_changed
      return false if @current_apis.size != @latest_apis.size
      @current_apis.each do |key, value|
        latest_api = @latest_apis.get(key)
        return false unless latest_api.nil? || (latest_api.digest != value.digest)
      end
      return true
    end

    # update API config
    def update
      if is_api_changed
        Util::write_api_config(@latest_apis.dump_config)
      end
    end

  end

end