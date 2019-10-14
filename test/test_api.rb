$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "jirest"

require "minitest/autorun"

class ApiInfoTableTest < Minitest::Test

  def setup
    Jirest.data_dir = './test/data'
    Jirest::stdin = STDIN
    Jirest::stdout = STDOUT
    Jirest::stderr = StringIO.new('test', 'r+')
    `mkdir -p #{Jirest.data_dir}`
  end

  def teardown
    `rm -rf #{Jirest.data_dir}`
  end

  def test_fail_to_load_apis
    # remove API definition
    `rm -rf #{Jirest.data_dir}/api.json`

    # initialize STDERR buffer
    Jirest::stderr.flush

    table = Jirest::ApiInfoTable.new
    table.load_apis

    Jirest.stderr.rewind
    assert_equal "\e[31merror: failed to load API definition!\n\e[0m",
                 Jirest.stderr.read
  end

  def test_dump_and_load_apis
    table = Jirest::ApiInfoTable.new
    api = Jirest::ApiInfo.new('name', 'path', 'description', [], 'command')
    table.set('name', api)
    table.dump_apis
    table2 = Jirest::ApiInfoTable.new
    table2.load_apis
    api2 = table2.get('name')
    assert_equal 'name', api2.name
    assert_equal 'path', api2.path
    assert_equal 'description', api2.description
    assert_equal 0, api2.params.size
    assert_equal 'command', api2.command
    assert_equal api.digest, api2.digest
  end

end

