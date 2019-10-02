require 'yaml'

module Jirest

  class ConfigManager

    def load_config(data_dir)
      config = nil
      begin
        config = YAML.load_file(data_dir + '/conf.yml')
      rescue
        Util::error 'unable to load config!'
        Util::msg 'please run "jirest init" command first to initialize config.'
        exit
      end
      return config
    end

    def init_config(data_dir)
      config = {}

      # base url
      STDERR.puts "What's your Jira Cloud Base URL? (e.g. https://xxxxx.atlassian.net)"
      STDERR.print '> '
      base_url = STDIN.gets.chomp
      STDERR.puts
      if not /^https\:\/\/.+\.atlassian\.net$/.match(base_url)
        Util::error 'the URL is not correct Jira Cloud Base URL format.'
        exit
      end

      # username
      STDERR.puts "What's your Jira Cloud username (mail address)? (e.g. xxxxx@gmail.com)"
      STDERR.print '> '
      user = STDIN.gets.chomp
      STDERR.puts
      if not /^.+@.+$/.match(user)
        Util::error 'the username is not correct Jira Cloud username format.'
        exit
      end

      # API token
      STDERR.puts "What's your Atlassian Cloud API Token?"
      STDERR.print '> '
      token = STDIN.gets.chomp
      STDERR.puts

      config['base-url'] = base_url
      config['user'] = user
      config['token'] = token

      YAML.dump(config, File.open(data_dir + '/conf.yml', 'w'))

      Util::msg 'new config was created.'
    end

  end

end
