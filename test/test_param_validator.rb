$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "jirest"

require "minitest/autorun"

class ParamValidatorTest < Minitest::Test

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

  def test_validate_boolean
    assert !Jirest::ParamValidator::validate('boolean', 'truuuuuuuue')
    assert Jirest::ParamValidator::validate('boolean', 'true')
    assert !Jirest::ParamValidator::validate('boolean', 'folse')
    assert Jirest::ParamValidator::validate('boolean', 'false')
  end

  def test_validate_integer
    assert !Jirest::ParamValidator::validate('integer', '111111a')
    assert !Jirest::ParamValidator::validate('integer', '')
    assert Jirest::ParamValidator::validate('integer', '0')
    assert Jirest::ParamValidator::validate('integer', '-123')
    assert Jirest::ParamValidator::validate('integer', '456')
  end

  def test_validate_number
    assert !Jirest::ParamValidator::validate('number', '100000a')
    assert !Jirest::ParamValidator::validate('number', '-456')
    assert Jirest::ParamValidator::validate('number', '12345')
  end

end

