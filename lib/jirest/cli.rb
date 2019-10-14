require "jirest"
require "thor"

module Jirest

  class << self
    attr_accessor :data_dir, :stdin, :stdout, :stderr
  end

  class Cli < Thor

    desc "init", "Initialize jirest config"
    def init
      ConfigManager.new.init_config
      Util::reset_api_definition
    end

    desc "describe", "Show information of a Jira REST API"
    def describe
      command_generator = CommandExecutor.new
      command_generator.describe
    end

    desc "update", "Update all API definitions"
    def update
      current_api_table = ApiInfoTable.new
      current_api_table.load_apis
      ApiInfoUpdater.new(current_api_table).update
    end

    desc "reset", "Reset all API definitions to the stable version"
    def reset
      Util::reset_apis
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

    desc "revert", "Revert a request template for a Jira REST API back to the default"
    def revert
      command_generator = CommandExecutor.new
      command_generator.revert
    end
  end
end