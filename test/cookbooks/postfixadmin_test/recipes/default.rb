# encoding: UTF-8
#
# Cookbook Name:: postfixadmin_test
# Recipe:: default
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2013-2015 Onddo Labs, SL.
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
#

node.default['postfixadmin']['database']['password'] = 'postfix_pass'
node.default['postfixadmin']['setup_password'] = 'admin'
node.default['postfixadmin']['setup_password_salt'] = 'salt'

include_recipe "postfixadmin_test::_#{node['postfixadmin']['database']['type']}"
include_recipe 'postfixadmin'
if node['postfixadmin']['web_server'].is_a?(String)
  include_recipe 'postfixadmin_test::_lwrp'
end

# Required for the integration tests
package 'patch'
package 'bzip2'
include_recipe 'phantomjs'
include_recipe 'nokogiri'
