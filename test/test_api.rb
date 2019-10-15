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


class ApiInfoUpdaterTest < Minitest::Test

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

  def test_is_api_changed
    table1 = Jirest::ApiInfoTable.new
    Jirest::ApiInfoUpdater.new(table1).update
    table2 = Jirest::ApiInfoTable.new
    table2.load_apis
    Jirest::ApiInfoUpdater.new(table2).update
    Jirest::stderr.rewind
    assert Jirest::stderr.read.include?('API Info is up to date.')
  end

  def test_update
    current_api_table = Jirest::ApiInfoTable.new
    Jirest::ApiInfoUpdater.new(current_api_table).update
    latest_api_table = Jirest::ApiInfoTable.new
    latest_api_table.load_apis

    assert latest_api_table.size > 0                  # number of APIs
    regex =                                           # regex for matching API name
        /^([a-z|A-Z|\(|\)|']+ )+[a-z|A-Z|\(|\)|']+$/
    is_correct_api_name = true
    latest_api_table.keys.each do |key|
      is_correct_api_name &= (key =~ regex)
    end
    assert is_correct_api_name
  end

end

