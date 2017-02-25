# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Recipe:: map_files
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
#

directory node['postfixadmin']['map_files']['path'] do
  mode '00755'
  owner node['postfixadmin']['map_files']['owner']
  group node['postfixadmin']['map_files']['group']
  recursive true
  not_if { ::File.exist?(node['postfixadmin']['map_files']['path']) }
  action :create
end

::Chef::Recipe.send(:include, Chef::EncryptedAttributesHelpers)
self.encrypted_attributes_enabled = node['postfixadmin']['encrypt_attributes']
password = encrypted_attribute_read(%w(postfixadmin database password))

node['postfixadmin']['map_files']['list'].each do |map_file|
  template "#{node['postfixadmin']['map_files']['path']}/#{map_file}" do
    source "sql/#{map_file}.erb"
    mode node['postfixadmin']['map_files']['mode']
    owner node['postfixadmin']['map_files']['owner']
    group node['postfixadmin']['map_files']['group']
    sensitive true
    variables(
      user: node['postfixadmin']['database']['user'],
      password: password,
      host: node['postfixadmin']['database']['host'],
      dbname: node['postfixadmin']['database']['name']
    )
    action :create
  end
end
