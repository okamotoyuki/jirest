require 'json'

module Atrestian

  class Util

    def self.load_api_config
      json = nil
      begin
        File.open('./conf/api.json', 'r') do |f|
          json = JSON.load(f)
        end
      rescue => e
        p 'error: failed to load config'
        p 'config updating...'
      end
      return json
    end

    def self.write_api_config(config)
      File.open('./conf/api.json', 'w') do |f|
        f.puts(JSON.generate(config))
      end
    end

  end

end
