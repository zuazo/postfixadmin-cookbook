#
# Cookbook Name:: postfixadmin
# Recipe:: default
#
# Copyright 2013, Onddo Labs, Sl.
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

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe 'database::mysql'
include_recipe 'mysql::server'

mysql_connection_info = {
  :host => node['postfixadmin']['database']['host'],
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database node['postfixadmin']['database']['name'] do
  connection mysql_connection_info
  action :create
end

if Chef::Config[:solo]
  if node['mysql']['database']['password'].nil?
    Chef::Application.fatal!("You must set node['mysql']['database']['password'] in chef-solo mode.");
  end
else
  # generate mysql password
  node.set_unless['postfixadmin']['database']['password'] = secure_password
  node.save
end

mysql_database_user node['postfixadmin']['database']['user'] do
  connection mysql_connection_info
  database_name node['postfixadmin']['database']['name']
  host node['postfixadmin']['database']['host']
  password node['postfixadmin']['database']['password']
  privileges [:all]
  action :grant
end

