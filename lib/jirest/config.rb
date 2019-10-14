require 'yaml'

module Jirest

  class ConfigManager

    def initialize
    end

    def load_config
      config = nil
      begin
        config = YAML.load_file(Jirest::data_dir + '/conf.yml')
      rescue
        Util::error 'unable to load config!'
        Util::msg 'please run "jirest init" command first to initialize config.'
        exit
      end
      return config
    end

    def init_config
      config = {}

      # base url
      Jirest::stderr.puts "What's your Jira Cloud Base URL? (e.g. https://xxxxx.atlassian.net)"
      Jirest::stderr.print '> '
      base_url = Jirest::stdin.gets.chomp
      Jirest::stderr.puts
      if not /^https\:\/\/.+\.atlassian\.net$/.match(base_url)
        Util::error 'the URL is not correct Jira Cloud Base URL format.'
        exit
      end

      # username
      Jirest::stderr.puts "What's your Jira Cloud username (mail address)? (e.g. xxxxx@gmail.com)"
      Jirest::stderr.print '> '
      user = Jirest::stdin.gets.chomp
      Jirest::stderr.puts
      if not /^.+@.+$/.match(user)
        Util::error 'the username is not correct Jira Cloud username format.'
        exit
      end

      # API token
      Jirest::stderr.puts "What's your Atlassian Cloud API Token?"
      Jirest::stderr.print '> '
      token = Jirest::stdin.gets.chomp
      Jirest::stderr.puts

      config['base-url'] = base_url
      config['user'] = user
      config['token'] = token

      YAML.dump(config, File.open(Jirest::data_dir + '/conf.yml', 'w'))

      Util::msg 'new config was created.'
    end

  end

end
