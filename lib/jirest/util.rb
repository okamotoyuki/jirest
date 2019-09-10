require 'json'
require 'yaml'

module Jirest

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

    def self.load_api_definition
      json = nil
      begin
        json = File.read('./data/api.json')
      rescue => e
        error 'failed to load API definition!'
      end
      return json
    end

    def self.dump_api_definition(json)
      begin
        File.write('./data/api.json', json)
      rescue => e
        error 'failed to store API definition!'
      end
    end

    def self.load_config
      return YAML.load_file(ENV['HOME'] + '/.jirest.yml')
    end

    # def self.create_temporary_file()
    # end

  end

end
