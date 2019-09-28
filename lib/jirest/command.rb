require 'tempfile'

module Jirest

  class CommandExecutor

    def initialize
      api_def = Util::load_api_definition(DATA_DIR)
      if api_def.nil?
        ApiInfoUpdater.new.update
        api_def = Util::load_api_definition(DATA_DIR)
      end
      @apis = ApiInfoTable.new(api_def)   # API table
      @params = {}                        # parameters

      @templates = {}                     # curl command templates
      user_def = Util::load_user_definition(DATA_DIR)
      @templates = JSON.parse(user_def) unless user_def.nil?
    end

    # print API names
    private def print_api_names
      str = ''
      @apis.keys.sort.each do |key|
        str += "#{key}\n"
      end
      return str.chomp
    end

    # execute peco command
    private def peco(input)
      unless input.nil?
        IO.popen('peco --select-1', 'r+') do |io|
          io.puts(input)
          io.close_write
          return io.gets.chomp
        end
      end
      return nil
    end

    # execute vim command
    private def vim(path)
      unless path.nil?
        IO.popen("</dev/tty vim #{path} 1>&2", 'r+') do |io|
        end
      end
    end

    # print API description
    private def print_api_description
      Util::print_red_bold_line(@target_api_info.name) # API name
      Util::msg ''
      Util::msg "\t#{@target_api_info.description}"
      Util::msg ''
    end

    # print API parameters
    private def print_api_parameters
      Util::print_bold_line "Parameters:"
      Util::msg ''
      if @target_api_info.params.empty?
        Util::msg "\tNo parameters."
      else
        @target_api_info.params.each do |param|
          print_api_parameter(param)
        end
      end
      puts
    end

    # print each API parameter
    private def print_api_parameter(param)
      Util::msg "\t◇ #{param['name']} (#{param['type']}):"
      print_as_multiple_lines(param['description'],"\t\t")
    end

    # print string as multiple lines
    private def print_as_multiple_lines(str, prefix='')
      default_max_columns = 90
      terminal_margin = 30
      columns = `stty size`.split[1].to_i
      max = columns > default_max_columns ? columns - terminal_margin : default_max_columns - terminal_margin

      # TODO : prevent the word in the end of line from being splitting into multiple part
      # e.g. 'Pseudoantidisestablishmentarianism' -> 'Pseudoantidisest' + 'ablishmentarianism'
      str.scan(/.{1,#{max}}/).each do |line|
        Util::msg "#{prefix}#{line}"
      end
    end

    # print API template
    private def print_api_template
      Util::print_bold_line "Template:"
      Util::msg ''
      @target_api_info.command.lines.each do |line|
        Util::print_gray_line("#{line}")
      end
    end

    # ask user to input parameters
    private def ask_params
      if @target_api_info.params.empty?
        return
      end

      Util::msg "please input parameters."
      Util::msg ''
      @target_api_info.params.each do |param|
        STDERR.puts "#{param['name']} (#{param['type']}):"
        STDERR.print '> '
        value = STDIN.gets.chomp
        @params[param['name']] = value
        STDERR.puts
      end
    end

    # ask if user wants to proceed
    private def ask_if_proceed
      regex = /^[ny]$/
      value = ''

      while not regex.match(value) do
        STDERR.puts "do you want to proceed? (y/n)"
        STDERR.print '> '
        value = STDIN.gets.chomp
      end

      if value == 'n'
        Util::msg 'exit process.'
        exit
      end
    end

    # generate executable curl command
    private def generate_curl_command
      command = @target_api_info.command

      # embed parameters
      @params.each do |key, value|
        command.gsub!("{#{key}}", value)
      end

      # load config
      conf = Util::load_config

      # embed credentials
      command.gsub!('curl', "curl -s -u:#{conf['user']}:#{conf['token']}")

      # embed Jira Base URL
      command.gsub!('--url \'', "--url '#{conf['base-url']}")

      return command
    end

    # describe API information
    def describe
      target_api_name = peco(print_api_names)
      @target_api_info = @apis.get(target_api_name)
      Util::msg ''
      print_api_description
      print_api_parameters
      print_api_template
    end

    # print curl command for API request
    def dryrun
      target_api_name = peco(print_api_names)
      @target_api_info = @apis.get(target_api_name)
      ask_params
      command = generate_curl_command
      puts command
    end

    # execute curl command for API request
    def exec
      target_api_name = peco(print_api_names)
      @target_api_info = @apis.get(target_api_name)
      ask_params
      command = generate_curl_command
      Util::msg "the following command is going to be executed."
      Util::msg ''
      Util::msg "`#{command}`"
      Util::msg ''
      ask_if_proceed
      Util::msg ''
      IO.popen(command, :err => [:child, :out]) do |io|
        puts io.gets.chomp
      end
    end

    # edit curl command template
    def edit
      target_api_name = peco(print_api_names)
      @target_api_info = @apis.get(target_api_name)
      template = @templates[target_api_name]
      template = @target_api_info.command if template.nil?

      Tempfile.open do |tmp|
        # print parameter information as a comments
        @target_api_info.params.each do |param|
          tmp.puts "#\t#{param['name']} (#{param['type']}):"
          tmp.puts "#\t\t#{param['description']}"
        end
        tmp.puts
        tmp.puts template
        tmp.flush
        vim(tmp.path)

        new_template = ''
        File.open(tmp.path, 'r') do |file|
          file.each_line do |line|
            next if line.start_with?('#') or line.match(/^\s*$/)  # ignore comments and empty lines
            new_template += line
          end
          new_template.chomp!
        end

        # if template is updated, store the new version
        if template != new_template
          @templates[target_api_name] = new_template
          Util::dump_user_definition(DATA_DIR, JSON.generate(@templates))
          Util::msg 'template is successfully stored.'
        end
      end
    end
  end

end
