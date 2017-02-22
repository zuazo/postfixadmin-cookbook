# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Library:: conf
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

require_relative 'php'

module PostfixadminCookbook
  # Method helpers to be used from configuration templates
  module Conf
    def self.value(value)
      case value
      when TrueClass then "'YES'"
      when FalseClass then "'NO'"
      else
        PostfixadminCookbook::PHP.ruby_value_to_php(value) || "'#{value}'"
      end
    end
  end
end
