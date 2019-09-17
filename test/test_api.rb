$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "jirest"

require "minitest/autorun"

class ApiInfoTableTest < Minitest::Test

  def test_serializer
    table = Jirest::ApiInfoTable.new
    api = Jirest::ApiInfo.new('name', 'path', 'description', [], 'command')
    table.set('name', api)
    table2 = Jirest::ApiInfoTable.new(table.serialize)
    api2 = table2.get('name')
    assert_equal 'name', api2.name
    assert_equal 'path', api2.path
    assert_equal 'description', api2.description
    assert_equal 0, api2.params.size
    assert_equal 'command', api2.command
    assert_equal api.digest, api2.digest
  end

end

