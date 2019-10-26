$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "jirest"

require "minitest/autorun"

class UtilTest < Minitest::Test

  def setup
    Jirest.data_dir = './test/data'
    Jirest::stdin = StringIO.new('test', 'r+')
    Jirest::stdout = StringIO.new('test', 'r+')
    Jirest::stderr = StringIO.new('test', 'r+')
    `mkdir -p #{Jirest.data_dir}`
  end

  def teardown
    `rm -rf #{Jirest.data_dir}`
  end

  def test_reset
    `touch #{Jirest.data_dir}/api.json`
    assert File.exist?("#{Jirest.data_dir}/api.json")
    Jirest::Util::reset_apis
    result = `diff api-stable.json #{Jirest.data_dir}/api.json`
    assert result == ''
  end

end

