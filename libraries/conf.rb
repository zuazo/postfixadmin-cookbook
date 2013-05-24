
module PostfixAdmin
  module Conf

    def self.value(v)
      if v.nil?
        'NULL'
      elsif v === true
        "'YES'"
      elsif v === false
        "'NO'"
      elsif v.kind_of?(Fixnum) or v.kind_of?(Float)
        v
      elsif v.kind_of?(Array)
        PostfixAdmin::PHP.array(v)
      elsif v.kind_of?(Hash)
        PostfixAdmin::PHP.hash(v)
      else
        "'#{v.to_s}'"
      end
    end

  end
end

