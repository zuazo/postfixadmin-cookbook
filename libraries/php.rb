# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Library:: php
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2013 Onddo Labs, SL.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative 'conf'

module PostfixadminCookbook
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
      when Integer, Float then value
      when Array then PostfixadminCookbook::PHP.array(value)
      when Hash then PostfixadminCookbook::PHP.hash(value)
      end
    end

    def self.php_from_template(template, obj)
      eruby = Erubis::Eruby.new(template)
      eruby.evaluate(obj: obj, PostfixAdmin_Conf: PostfixadminCookbook::Conf)
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
    "#{@PostfixAdmin_Conf.value(k)} => #{@PostfixAdmin_Conf.value(v)}"
  end.join(", ")
%>)'
      php_from_template(template, hs)
    end
  end
end
