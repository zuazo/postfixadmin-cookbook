# encoding: UTF-8

module PostfixAdmin
  # Some helpers to emulate some PHP functions
  module PHP
    def mt_rand(min, max)
      require 'openssl'

      diff = max - min
      bytes = (diff.to_s(16).length.to_f / 2).ceil
      min + (
        OpenSSL::Random.random_bytes(bytes).unpack('C' * bytes).join.to_i % diff
      )
    end

    def generate_setup_password_salt
      require 'digest/md5'

      salt = "#{Time.new.to_i}*#{node['fqdn']}*#{mt_rand(0, 60_000)}"
      ::Digest::MD5.hexdigest(salt)
    end

    def encrypt_setup_password(password, salt)
      require 'digest/sha1'

      "#{salt}:#{::Digest::SHA1.hexdigest("#{salt}:#{password}")}"
    end

    def self.ruby_value_to_php(value)
      case value
      when nil then 'NULL'
      when Fixnum, Float then v
      when Array then PostfixAdmin::PHP.array(v)
      when Hash then PostfixAdmin::PHP.hash(v)
      end
    end

    def self.php_from_template(template, obj)
      eruby = Erubis::Eruby.new(template)
      eruby.evaluate(obj: obj, PostfixAdmin_Conf: PostfixAdmin::Conf)
    end

    def self.array(ary)
      template =
'array(<%=
  list = @obj.kind_of?(Array) ? @obj : [ @obj ]
  list.map do |item|
    @PostfixAdmin_Conf.value(item)
  end.join(", ")
%>)'
      php_from_template(template, ary)
    end

    def self.hash(hs)
      template =
'array(<%=
  @obj.to_hash.sort.map do |k, v|
    "#{@PostfixAdmin_Conf.value(v)} => #{@PostfixAdmin_Conf.value(k)}"
  end.join(", ")
%>)'
      php_from_template(template, hs)
    end
  end
end
