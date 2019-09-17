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

    def self.load_api_definition(data_dir)
      json = nil
      begin
        json = File.read(data_dir + '/api.json')
      rescue => e
        error 'failed to load API definition!'
      end
      return json
    end

    def self.dump_api_definition(data_dir, json)
      begin
        File.write(data_dir + '/api.json', json)
      rescue => e
        error 'failed to store API definition!'
      end
    end

    def self.load_user_definition(data_dir)
      json = nil
      begin
        json = File.read(data_dir + '/user.json')
      rescue => e
        # do nothing
      end
      return json
    end

    def self.dump_user_definition(data_dir, json)
      begin
        File.write(data_dir + '/user.json', json)
      rescue => e
        error 'failed to store user definition!'
      end
    end

    def self.load_config
      return YAML.load_file(ENV['HOME'] + '/.jirest.yml')
    end

  end

end
