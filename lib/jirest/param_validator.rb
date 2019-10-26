module Jirest

  # A class which validates parameter
  class ParamValidator

    def self.validate(type, param)
      case type
      when 'boolean'
        return validate_boolean(param)
      when 'integer'
        return validate_integer(param)
      when 'number'
        return validate_number(param)
      when 'string'
        return validate_string(param)
      when 'anything'
        return true
      else
        if type =~ /^Array<.+>$/
          return true
        end
      end
      return false
    end

    def self.validate_boolean(param)
      return false unless param == 'true' or param == 'false'
      return true
    end

    def self.validate_integer(param)
      return param =~ /\A[+-]?[1-9][0-9]*\z/
    end

    def self.validate_number(param)
      return param =~ /\A[1-9][0-9]*\z/
    end

    def self.validate_string(param)
      # TODO check escape sequence
      return true
    end

  end

end