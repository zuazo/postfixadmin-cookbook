# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Recipe:: apache
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

Chef::Recipe.send(:include, PostfixadminCookbook::RecipeHelpers)

def update_listen_ports(port)
  listen_ports = node['apache']['listen_ports']
  if listen_ports.nil?
    node.default['apache']['listen_ports'] = [port]
  elsif !listen_ports.include?(port)
    node.default['apache']['listen_ports'] = listen_ports + [port]
  end
end

# Fix apache cookbook version 3.2.2 issue:
# https://github.com/sous-chefs/apache2/pull/422
def fix_apache_cookbook_pr422
  if node['apache']['listen_addresses'].nil?
    node.default['apache']['listen_addresses'] = %w(*)
  end
  if node['apache']['listen_ports'].nil?
    node.default['apache']['listen_ports'] = %w(80 443)
  end
end

fix_apache_cookbook_pr422

default_port = self.default_port
default_ssl = self.default_ssl

update_listen_ports(default_port)

include_recipe 'apache2::default'
include_recipe 'php'
include_recipe 'apache2::mod_php5'

if default_ssl
  cert = ssl_certificate 'postfixadmin' do
    namespace node['postfixadmin']
    notifies :restart, 'service[apache2]'
  end

  include_recipe 'apache2::mod_ssl'
end

# Create virtualhost
web_app 'postfixadmin' do
  cookbook 'postfixadmin'
  template 'apache_vhost.erb'
  docroot "#{node['ark']['prefix_root']}/postfixadmin"
  server_name node['postfixadmin']['server_name']
  server_aliases node['postfixadmin']['server_aliases']
  headers node['postfixadmin']['headers']
  port default_port
  directory_options %w(-Indexes +FollowSymLinks +MultiViews)
  if default_ssl
    ssl_key cert.key_path
    ssl_cert cert.cert_path
    ssl_chain cert.chain_path
    ssl true
  end
  enable true
end

# Disable old cookbook versions SSL VirtualHost
apache_site 'postfixadmin-ssl' do
  enable false
end

# required by the lwrps
ruby_block 'web_app-postfixadmin-reload' do
  block {}
  subscribes :create, 'execute[a2ensite postfixadmin.conf]', :immediately
  # required by lwrp-ssl-centos-510:
  subscribes :create, 'template[config.local.php]', :immediately
  notifies :restart, 'service[apache2]', :immediately
end
