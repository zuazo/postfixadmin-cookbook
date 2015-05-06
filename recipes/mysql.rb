# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Recipe:: mysql
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL. (www.onddo.com)
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

Chef::Recipe.send(:include, Chef::EncryptedAttributesHelpers)
# include the #secure_password method:
Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe 'postfixadmin::mysql_cookbook_fix'

def mysql_password(user)
  key = "server_#{user}_password"
  encrypted_attribute_write(['postfixadmin', 'mysql', key]) { secure_password }
end

self.encrypted_attributes_enabled = node['postfixadmin']['encrypt_attributes']

root_password = mysql_password('root')
debian_password = mysql_password('debian')
repl_password = mysql_password('repl')

mysql_service node['mysql']['service_name'] do
  version node['mysql']['version']
  port node['mysql']['port']
  data_dir node['mysql']['data_dir']
  server_root_password root_password
  server_debian_password debian_password
  server_repl_password repl_password
  allow_remote_root node['mysql']['allow_remote_root']
  remove_anonymous_users node['mysql']['remove_anonymous_users']
  remove_test_database node['mysql']['remove_test_database']
  root_network_acl node['mysql']['root_network_acl']
  action :create
end
