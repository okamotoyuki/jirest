require 'json'

module Atrestian

  class Util

    def self.error(msg)
      print "\e[31m"
      puts "error: #{msg}"
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
        msg 'config updating...'
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
