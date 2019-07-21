require "atrestian"
require "thor"

module Atrestian
  class Cli < Thor

    desc "exec", "exec"
    def exec
    end

    desc "update", "update"
    def update
      api_info_updater = ApiInfoUpdater.new
      api_info_updater.update
    end

  end
end