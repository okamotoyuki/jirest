require 'json'

module Atrestian

  class Util

    def self.error(msg)
      print_red_line "error: #{msg}"
    end

    def self.print_red_line(str)
      print "\e[31m"
      puts str
      print "\e[0m"
    end

    def self.print_bold_line(str)
      print "\e[1m"
      puts str
      print "\e[0m"
    end

    def self.print_red_bold_line(str)
      print "\e[31;1m"
      puts str
      print "\e[0m"
    end

    def self.print_gray_line(str)
      print "\e[37m"
      puts str
      print "\e[0m"
    end

    def self.msg(str)
      puts str
    end

    def self.load_api_config
      json = nil
      begin
        json = File.read('./conf/api.json')
      rescue => e
        error 'failed to load config!'
      end
      return json
    end

    def self.dump_api_config(json)
      begin
        File.write('./conf/api.json', json)
      rescue => e
        error 'failed to store config!'
      end
    end

  end

end
