require "jirest"
require "thor"

module Jirest

  DATA_DIR = './data'

  class Cli < Thor

    desc "init", "Initialize jirest config"
    def init
      ConfigManager.new.init_config(DATA_DIR)
      Util::revert_api_definition(DATA_DIR)
    end

    desc "describe", "Show information of a Jira REST API"
    def describe
      command_generator = CommandExecutor.new
      command_generator.describe
    end

    desc "update", "Update all API definitions"
    def update
      api_def = Util::load_api_definition(DATA_DIR)
      ApiInfoUpdater.new(api_def).update
    end

    desc "revert", "Revert all API definitions back to the stable version"
    def revert
      Util::revert_api_definition(DATA_DIR)
    end

    desc "dryrun", "Generate a curl command to use a Jira REST API"
    def dryrun
      command_generator = CommandExecutor.new
      command_generator.dryrun
    end

    desc "exec", "Execute a curl command to use a Jira REST API"
    def exec
      command_generator = CommandExecutor.new
      command_generator.exec
    end

    desc "edit", "Edit a request template for a Jira REST API"
    def edit
      command_generator = CommandExecutor.new
      command_generator.edit
    end

  end
end