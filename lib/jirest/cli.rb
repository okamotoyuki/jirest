require "jirest"
require "thor"

module Jirest
  class Cli < Thor

    desc "describe", "describe"
    def describe
      command_generator = CommandExecutor.new
      command_generator.describe
    end

    desc "update", "update"
    def update
      api_config = Util::load_api_config
      ApiInfoUpdater.new(api_config).update
    end

  end
end