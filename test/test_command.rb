$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "jirest"

require "minitest/autorun"

class CommandExecutorTest < Minitest::Test

  def setup
    Jirest.data_dir = './test/data'
    Jirest::stdin = StringIO.new("test", 'r+')
    Jirest::stdout = StringIO.new('test', 'r+')
    Jirest::stderr = StringIO.new('test', 'r+')
    `mkdir -p #{Jirest.data_dir}`
    `cp ./test/conf_dummy.yml #{Jirest.data_dir}/conf.yml`
  end

  def teardown
    `rm -rf #{Jirest.data_dir}`
  end

  def test_describe
    command_executor = Jirest::CommandExecutor.new
    command_executor.describe("Get all dashboards")
    Jirest::stderr.rewind
    result = Jirest::stderr.read
    assert result.include?('Get all dashboards')
    assert result.include?('Parameters:')
    assert result.include?('Template:')
  end

  def test_dryrun
    Jirest::stdin = StringIO.new("filter\n1\n10", 'r+')
    command_executor = Jirest::CommandExecutor.new
    command_executor.dryrun("Get all dashboards")
    Jirest::stdout.rewind
    result = Jirest::stdout.read
    assert result.include?("--url 'https://xxxxx.atlassian.net/rest/api/3/dashboard'")
    assert result.include?('--user yyyyy@gmail.com:zzzzz')
    assert result.include?("--header 'Accept: application/json'")
  end

  def test_revert
    `cp ./test/user_dummy.json #{Jirest.data_dir}/user.json`
    json = Jirest::Util.load_user_def
    assert json.include?('{"Get all dashboards":"test"}')
    command_executor = Jirest::CommandExecutor.new
    command_executor.revert("Get all dashboards")
    json2 = Jirest::Util.load_user_def
    assert json2.include?('{}')
    `rm #{Jirest.data_dir}/user.json`
  end

end
