#
# Cookbook Name:: postfixadmin
# Recipe:: apache
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

include_recipe 'apache2::default'
include_recipe 'apache2::mod_php5'

if node['postfixadmin']['ssl']
  include_recipe 'apache2::mod_ssl'
end

# required by the lwrps
ruby_block 'web_app-postfixadmin-reload' do
  block {}
  subscribes :create, 'execute[a2ensite postfixadmin.conf]', :immediately
  notifies :reload, 'service[apache2]', :immediately
end

web_app 'postfixadmin' do
  cookbook 'postfixadmin'
  template 'vhost.erb'
  docroot "#{node['ark']['prefix_root']}/postfixadmin"
  server_name node['postfixadmin']['server_name']
  server_aliases []
  if node['postfixadmin']['ssl']
    port '443'
  else
    port '80'
  end
  enable true
end
