# encoding: UTF-8
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

# Create virtualhost for PostfixAdmin
web_app 'postfixadmin' do
  cookbook 'postfixadmin'
  template 'apache_vhost.erb'
  docroot "#{node['ark']['prefix_root']}/postfixadmin"
  server_name node['postfixadmin']['server_name']
  server_aliases node['postfixadmin']['server_aliases']
  headers node['postfixadmin']['headers']
  port '80'
  directory_options %w(-Indexes +FollowSymLinks +MultiViews)
  enable true
end

if node['postfixadmin']['ssl']
  cert = ssl_certificate 'postfixadmin' do
    namespace node['postfixadmin']
    notifies :restart, 'service[apache2]'
  end

  include_recipe 'apache2::mod_ssl'

  # Create SSL virtualhost
  web_app 'postfixadmin-ssl' do
    cookbook 'postfixadmin'
    template 'apache_vhost.erb'
    docroot "#{node['ark']['prefix_root']}/postfixadmin"
    server_name node['postfixadmin']['server_name']
    server_aliases node['postfixadmin']['server_aliases']
    headers node['postfixadmin']['headers']
    port '443'
    directory_options %w(-Indexes +FollowSymLinks +MultiViews)
    ssl_key cert.key_path
    ssl_cert cert.cert_path
    enable true
  end
end

# required by the lwrps
ruby_block 'web_app-postfixadmin-reload' do
  block {}
  subscribes :create, 'execute[a2ensite postfixadmin.conf]', :immediately
  # required by lwrp-ssl-centos-510:
  subscribes :create, 'template[config.local.php]', :immediately
  notifies :reload, 'service[apache2]', :immediately
end
