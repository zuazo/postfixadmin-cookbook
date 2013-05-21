#
# Cookbook Name:: postfixadmin
# Recipe:: map_files
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

directory node['postfixadmin']['map_files']['path'] do
  mode '00755'
  owner node['postfixadmin']['map_files']['owner']
  group node['postfixadmin']['map_files']['group']
  recursive true
  action :create
end

node['postfixadmin']['map_files']['list'].each do |map_file|
  template "#{node['postfixadmin']['maps_path']}/#{map_file}" do
    source "sql/#{map_file}.erb"
    mode node['postfixadmin']['map_files']['mode']
    owner node['postfixadmin']['map_files']['owner']
    group node['postfixadmin']['map_files']['group']
    variables(
      :user => node['postfixadmin']['database']['user'],
      :password => node['postfixadmin']['database']['password'],
      :host => node['postfixadmin']['database']['host'],
      :dbname => node['postfixadmin']['database']['name']
    )
    action :create
  end
end


