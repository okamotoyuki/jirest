require 'open-uri'
require 'nokogiri'
require 'digest/sha2'

module Jirest

  API_DOC_URI = 'https://developer.atlassian.com/cloud/jira/platform/rest/v3'

  # A class which stands REST API information
  class ApiInfo

    attr_reader :name, :path, :description, :params, :command, :digest

    def initialize(name, path, description, params, command, digest=nil)
      @name = name
      @path = path
      @description = description
      @params = params
      @command = command
      @digest = digest || calc_digest
    end

    private def calc_digest
      str = @name
      str += @description
      @params.each do |param|
        str += param['name'] # param name
      end
      str += @command
      return Digest::SHA256.hexdigest(str)
    end

  end

  # A class which store all the REST API information
  class ApiInfoTable

    def initialize(json=nil)
      @hash = {}
      deserialize(json) unless json.nil?
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

    def keys
      return @hash.keys
    end

    def each
      if block_given?
        @hash.each do |key, value|
          yield(key, value)
        end
      end
    end

    # convert Ruby object information to json
    def serialize
      obj = {}
      @hash.each do |key, value|
        api = {}
        api['name'] = value.name
        api['path'] = value.path
        api['description'] = value.description
        api['params'] = value.params
        api['command'] = value.command
        api['digest'] = value.digest
        obj[key] = api
      end
      return JSON.generate(obj)
    end

    # convert json to Ruby object
    private def deserialize(json)
      JSON.parse(json).each do |key, value|
        @hash[key] =
            ApiInfo.new(value['name'], value['path'], value['description'],
                        value['params'], value['command'], value['digest'])
      end
    end

  end

  # A class which is for updating REST API information
  class ApiInfoUpdater

    def initialize(api_config=nil)
      Util::msg 'config updating...' if api_config.nil?
      @current_apis = ApiInfoTable.new(api_config)
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

        # extract API path
        path = h3.next.content

        # extract API description
        description = h3.next.next.content

        # extract parameters
        params = []
        h5_arr = root_api_elem.css('h5')
        if not h5_arr.empty? and h5_arr.first.content.end_with?('parameters')
          section_arr = h5_arr.first.parent.css('section')
          unless section_arr.empty?
            section_arr.each do |section|
              param_info = {}
              strong_arr = section.css('strong')
              param_info['name'] = strong_arr[0].content.chomp(' ') unless strong_arr.empty?
              span_arr = section.css('p > span')
              param_info['type'] = span_arr[0].content.chomp(' ') unless span_arr.empty?
              p_arr = section.css('div > p')
              param_info['description'] = p_arr[0].content.chomp(' ') unless p_arr.empty?
              code_arr = section.css('div > span > span > span > code')
              param_info['default'] = code_arr[0].content.chomp(' ') unless code_arr.empty?
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

        latest_apis.set(name, ApiInfo.new(name, path, description, params, command))
      end

      return latest_apis
    end

    # check if any API is changed on the API reference
    private def is_api_changed
      return true if @current_apis.size != @latest_apis.size
      @current_apis.each do |key, value|
        latest_api = @latest_apis.get(key)
        return true if latest_api.nil? || (latest_api.digest != value.digest)
      end
      return false
    end

    # update API config
    def update
      if is_api_changed
        Util::dump_api_config(@latest_apis.serialize)
      else
        Util::msg 'API Info is up to date.'
      end
    end

  end

end