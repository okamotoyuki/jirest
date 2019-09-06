module Jirest

  class CommandExecutor

    def initialize
      api_config = Util::load_api_config
      if api_config.nil?
        ApiInfoUpdater.new.update
        api_config = Util::load_api_config
      end
      @apis = ApiInfoTable.new(api_config)
      puts
    end

    # print API names
    def print_api_names
      str = ''
      @apis.keys.sort.each do |key|
        str += "#{key}\n"
      end
      return str.chomp
    end

    # execute peco command
    def peco(input)
      unless input.nil?
        IO.popen('peco --select-1', 'r+') do |io|
          io.puts(input)
          io.close_write
          return io.gets.chomp
        end
      end
      return nil
    end

    # print API description
    private def print_api_description
      Util::print_red_bold_line(@target_api_info.name) # API name
      puts
      puts "\t#{@target_api_info.description}"
      puts
    end

    # print API parameters
    private def print_api_parameters
      Util::print_bold_line "Parameters:"
      puts
      if @target_api_info.params.empty?
        puts "\tNo parameters."
      else
        @target_api_info.params.each do |param|
          print_api_parameter(param)
        end
      end
      puts
    end

    # print each API parameter
    private def print_api_parameter(param)
      puts "\t#{param['name']} (#{param['type']}):"
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
        puts "#{prefix}#{line}"
      end
    end

    # print API sample
    private def print_api_sample
      Util::print_bold_line "Sample:"
      puts
      @target_api_info.command.lines.each do |line|
        Util::print_gray_line("#{line}")
      end
    end

    # describe API information
    def describe
      target_api_name = peco(print_api_names)
      @target_api_info = @apis.get(target_api_name)
      print_api_description
      print_api_parameters
      print_api_sample
    end

  end

end
