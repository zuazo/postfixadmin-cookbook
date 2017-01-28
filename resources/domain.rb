# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Resource:: domain
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

actions :create

attribute :domain, kind_of: String, name_attribute: true
attribute :description, kind_of: String, default: ''
attribute :aliases, kind_of: Integer, default: 10
attribute :mailboxes, kind_of: Integer, default: 10
attribute :login_username, kind_of: String, required: true
attribute :login_password, kind_of: String, required: true
attribute :db_type, equal_to: %w(mysql postgresql)
attribute :db_user, kind_of: String
attribute :db_password, kind_of: String
attribute :db_name, kind_of: String
attribute :db_host, kind_of: String
attribute :db_port, kind_of: [Integer, String]
attribute :ssl, kind_of: [TrueClass, FalseClass]
attribute :port, kind_of: [Integer, String]

def initialize(*args)
  super
  @action = :create
end
