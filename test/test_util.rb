$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "jirest"

require "minitest/autorun"

class UtilTest < Minitest::Test

  DATA_DIR = './test/data'

  def setup
    `mkdir -p #{DATA_DIR}`
  end

  def teardown
    `rm -rf #{DATA_DIR}`
  end

  def test_api_definition_loader
    Jirest::Util::dump_api_definition(DATA_DIR, '{"key":"value"}')
    json = Jirest::Util::load_api_definition(DATA_DIR)
    assert_equal '{"key":"value"}', json
  end

  def test_user_definition_loader
    Jirest::Util::dump_user_definition(DATA_DIR, '{"key":"value"}')
    json = Jirest::Util::load_user_definition(DATA_DIR)
    assert_equal '{"key":"value"}', json
  end

end

