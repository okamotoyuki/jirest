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
      api_def = Util::load_api_definition
      ApiInfoUpdater.new(api_def).update
    end

    desc "dryrun", "dryrun"
    def dryrun
      command_generator = CommandExecutor.new
      command_generator.dryrun
    end

    desc "exec", "exec"
    def exec
      command_generator = CommandExecutor.new
      command_generator.exec
    end

    desc "edit", "edit"
    def edit
      command_generator = CommandExecutor.new
      command_generator.edit
    end

  end
end