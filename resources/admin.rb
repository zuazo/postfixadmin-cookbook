# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Resource:: admin
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

actions :create, :remove

attribute :user, kind_of: String, name_attribute: true
attribute :password, kind_of: String, default: 'p@ssw0rd1'
attribute :setup_password, kind_of: String
attribute :superadmin, kind_of: [TrueClass, FalseClass], default: true
attribute :domains, kind_of: [Array, String], default: true
attribute :active, kind_of: [TrueClass, FalseClass], default: true
attribute :login_username, kind_of: String
attribute :login_password, kind_of: String
attribute :ssl, kind_of: [TrueClass, FalseClass]
attribute :port, kind_of: [Integer, String]

def initialize(*args)
  super
  @action = :create
end
