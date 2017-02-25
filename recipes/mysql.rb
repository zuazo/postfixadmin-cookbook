# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Recipe:: mysql
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2014-2015 Onddo Labs, SL.
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
Chef::Recipe.send(:include, OpenSSLCookbook::RandomPassword)

def mysql_password(user)
  key = "server_#{user}_password"
  encrypted_attribute_write(['postfixadmin', 'mysql', key]) { random_password }
end

self.encrypted_attributes_enabled = node['postfixadmin']['encrypt_attributes']

root_password = mysql_password('root')

mysql_service node['postfixadmin']['mysql']['instance'] do
  unless node['postfixadmin']['mysql']['data_dir'].nil?
    data_dir node['postfixadmin']['mysql']['data_dir']
  end
  initial_root_password root_password
  bind_address '127.0.0.1'
  port node['postfixadmin']['mysql']['port']
  unless node['postfixadmin']['mysql']['run_group'].nil?
    run_group node['postfixadmin']['mysql']['run_group']
  end
  unless node['postfixadmin']['mysql']['run_user'].nil?
    run_user node['postfixadmin']['mysql']['run_user']
  end
  unless node['postfixadmin']['mysql']['version'].nil?
    version node['postfixadmin']['mysql']['version']
  end
  action [:create, :start]
end
