# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Recipe:: nginx
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2015 Onddo Labs, SL.
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

include_recipe 'chef_nginx'
include_recipe 'postfixadmin::php_fpm'

# Disable apache2, required for Debian 6
service 'apache2' do
  action [:stop, :disable]
  only_if { ::File.exist?('/etc/init.d/apache2') }
end

fastcgi_pass =
  "unix:/var/run/php-fpm-#{node['postfixadmin']['php-fpm']['pool']}.sock"

template_variables = {
  name: 'postfixadmin',
  server_name: node['postfixadmin']['server_name'],
  server_aliases: node['postfixadmin']['server_aliases'],
  docroot: "#{node['ark']['prefix_root']}/postfixadmin",
  port: default_port,
  fastcgi_pass: fastcgi_pass,
  headers: node['postfixadmin']['headers']
}

if default_ssl
  cert = ssl_certificate 'postfixadmin' do
    namespace node['postfixadmin']
    notifies :restart, 'service[nginx]' # TODO: reload?
  end

  template_variables.merge!(
    ssl_key: cert.key_path,
    ssl_cert: cert.chain_combined_path,
    ssl: true
  )
end

# Create virtualhost
template File.join(node['nginx']['dir'], 'sites-available', 'postfixadmin') do
  source 'nginx_vhost.erb'
  mode 00644
  owner 'root'
  group 'root'
  variables(template_variables)
  notifies :reload, 'service[nginx]'
end

nginx_site 'postfixadmin' do
  enable true
  notifies :restart, 'service[nginx]', :immediately
  notifies :restart, 'service[php-fpm]', :immediately
end
