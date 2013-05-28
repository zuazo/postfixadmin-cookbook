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
::Chef::Recipe.send(:include, PostfixAdmin::PHP)

include_recipe 'apache2::default'
include_recipe 'apache2::mod_php5'
include_recipe 'database::mysql'
include_recipe 'mysql::server'

pkg_php_mysql = value_for_platform(
  %w(centos redhat scientific fedora amazon) => {
    %w(5.0 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8) => 'php53-mysql',
    'default' => 'php-mysql'
  },
  'default' => 'php5-mysql'
)

pkg_php_imap = value_for_platform(
  %w(centos redhat scientific fedora amazon) => {
    %w(5.0 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8) => 'php53-imap',
    'default' => 'php-imap'
  },
  'default' => 'php5-imap'
)

pkg_php_mbstring = value_for_platform(
  %w(centos redhat scientific fedora amazon) => {
    %w(5.0 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8) => 'php53-mbstring',
    'default' => 'php-mbstring'
  },
  'default' => nil
)

package pkg_php_mysql do
  action :install
end

package pkg_php_imap do
  action :install
end

package pkg_php_mbstring do
  not_if do pkg_php_mbstring.nil? end
  action :install
end

chef_gem 'sequel'

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
  if node['postfixadmin']['database']['password'].nil?
    Chef::Application.fatal!("You must set node['postfixadmin']['database']['password'] in chef-solo mode.");
  end
  if node['postfixadmin']['setup_password'].nil?
    Chef::Application.fatal!("You must set node['postfixadmin']['setup_password'] in chef-solo mode.");
  end
  if node['postfixadmin']['setup_password_salt'].nil?
    Chef::Application.fatal!("You must set node['postfixadmin']['setup_password_salt'] in chef-solo mode.");
  end
  node.set_unless['postfixadmin']['setup_password_encrypted'] = encrypt_setup_password(node['postfixadmin']['setup_password'], node['postfixadmin']['setup_password_salt'])
else
  # generate required passwords
  node.set_unless['postfixadmin']['database']['password'] = secure_password
  node.set_unless['postfixadmin']['setup_password'] = secure_password
  node.set_unless['postfixadmin']['setup_password_encrypted'] = encrypt_setup_password(node['postfixadmin']['setup_password'], generate_setup_password_salt)
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

ark 'postfixadmin' do
  url node['postfixadmin']['url']
  version node['postfixadmin']['version']
  checksum node['postfixadmin']['checksum']
end

if node['postfixadmin']['ssl']
  include_recipe 'apache2::mod_ssl'
  package 'ssl-cert' # generates a self-signed (snakeoil) certificate
end

template 'config.local.php' do
  path "#{node['ark']['prefix_root']}/postfixadmin/config.local.php"
  source 'config.local.php.erb'
  owner 'root'
  group node['apache']['group']
  mode '0640'
  variables(
    :name => node['postfixadmin']['database']['name'],
    :host => node['postfixadmin']['database']['host'],
    :user => node['postfixadmin']['database']['user'],
    :password => node['postfixadmin']['database']['password'],
    :setup_password => node['postfixadmin']['setup_password_encrypted'],
    :conf => node['postfixadmin']['conf']
  )
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
  notifies :reload, resources(:service => "apache2"), :immediately
end

