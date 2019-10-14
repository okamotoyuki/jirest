require 'json'
require 'yaml'

module Jirest

  class Util

    def self.error(msg)
      print_red_line "error: #{msg}"
    end

    def self.print_red_line(str)
      Jirest::stderr.print "\e[31m"
      Jirest::stderr.puts str
      Jirest::stderr.print "\e[0m"
    end

    def self.print_bold_line(str)
      Jirest::stderr.print "\e[1m"
      Jirest::stderr.puts str
      Jirest::stderr.print "\e[0m"
    end

    def self.print_red_bold_line(str)
      Jirest::stderr.print "\e[31;1m"
      Jirest::stderr.puts str
      Jirest::stderr.print "\e[0m"
    end

    def self.print_gray_line(str)
      Jirest::stderr.print "\e[37m"
      Jirest::stderr.puts str
      Jirest::stderr.print "\e[0m"
    end

    def self.msg(str)
      Jirest::stderr.puts str
    end

    def self.load_user_def
      json = nil
      begin
        json = File.read(Jirest::data_dir + '/user.json')
      rescue => e
        # do nothing
      end
      return json
    end

    def self.dump_user_def(json)
      begin
        File.write(Jirest::data_dir + '/user.json', json)
      rescue => e
        error 'failed to store user definition!'
      end
    end

    def self.reset_apis
      `cp -r api-stable.json #{Jirest::data_dir}/api.json`
      msg 'API Info was reset to the stable version.'
    end

  end

end
