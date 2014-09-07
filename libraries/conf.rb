# encoding: UTF-8

module PostfixAdmin
  # Method helpers to be used from configuration templates
  module Conf
    def self.value(value)
      case value
      when TrueClass then "'YES'"
      when FalseClass then "'NO'"
      else
        PostfixAdmin::PHP.ruby_value_to_php(value) || "'#{value}'"
      end
    end
  end
end
