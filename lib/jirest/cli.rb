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
      Util::reset_apis
    end

    desc "describe [KEYWORD]", "Show information of a Jira REST API"
    def describe(keyword=nil)
      command_executor = CommandExecutor.new
      command_executor.describe(keyword)
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

    desc "dryrun [KEYWORD]", "Generate a curl command to use a Jira REST API"
    def dryrun(keyword=nil)
      command_executor = CommandExecutor.new
      command_executor.dryrun(keyword)
    end

    desc "exec [KEYWORD]", "Execute a curl command to use a Jira REST API"
    def exec(keyword=nil)
      command_executor = CommandExecutor.new
      command_executor.exec(keyword)
    end

    desc "edit [KEYWORD]", "Edit a request template for a Jira REST API"
    def edit(keyword=nil)
      command_executor = CommandExecutor.new
      command_executor.edit(keyword)
    end

    desc "revert [KEYWORD]", "Revert a request template for a Jira REST API back to the default"
    def revert(keyword=nil)
      command_executor = CommandExecutor.new
      command_executor.revert(keyword)
    end
  end
end