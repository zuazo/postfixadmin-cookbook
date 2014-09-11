# encoding: UTF-8
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

db_type = node['postfixadmin']['database']['type']

include_recipe "#{db_type}::server"
include_recipe "database::#{db_type}"

pkgs_php_db =
  if db_type != 'requirements' && node['postfixadmin']['packages'].key?(db_type)
    node['postfixadmin']['packages'][db_type]
  else
    fail "Unknown database type: #{db_type}"
  end
pkgs_php_db.each do |pkg|
  package pkg do
    action :install
  end
end

node['postfixadmin']['packages']['requirements'].each do |pkg|
  package pkg do
    action :install
  end
end

if Chef::Config[:solo]
  if node['postfixadmin']['database']['password'].nil?
    fail 'You must set node["postfixadmin"]["database"]["password"] in '\
      'chef-solo mode.'
  end
  if node['postfixadmin']['setup_password'].nil?
    fail 'You must set node["postfixadmin"]["setup_password"] in chef-solo '\
      'mode.'
  end
  if node['postfixadmin']['setup_password_salt'].nil?
    fail 'You must set node["postfixadmin"]["setup_password_salt"] in '\
      'chef-solo mode.'
  end
  node.set_unless['postfixadmin']['setup_password_encrypted'] =
    encrypt_setup_password(
      node['postfixadmin']['setup_password'],
      node['postfixadmin']['setup_password_salt']
    )
else
  # generate required passwords
  node.set_unless['postfixadmin']['database']['password'] = secure_password
  node.set_unless['postfixadmin']['setup_password'] = secure_password
  node.set_unless['postfixadmin']['setup_password_encrypted'] =
    encrypt_setup_password(
      node['postfixadmin']['setup_password'],
      generate_setup_password_salt
    )
  node.save
end

chef_gem 'sequel'

case db_type
when 'mysql'

  mysql_connection_info = {
    host: node['postfixadmin']['database']['host'],
    username: 'root',
    password: node['mysql']['server_root_password']
  }

  mysql_database node['postfixadmin']['database']['name'] do
    connection mysql_connection_info
    action :create
  end

  mysql_database_user node['postfixadmin']['database']['user'] do
    connection mysql_connection_info
    database_name node['postfixadmin']['database']['name']
    host node['postfixadmin']['database']['host']
    password node['postfixadmin']['database']['password']
    privileges [:all]
    action :grant
  end

when 'postgresql'

  postgresql_connection_info = {
    host: 'localhost',
    username: 'postgres',
    password: node['postgresql']['password']['postgres']
  }

  postgresql_database node['postfixadmin']['database']['name'] do
    connection postgresql_connection_info
    action :create
  end

  postgresql_database_user node['postfixadmin']['database']['user'] do
    connection postgresql_connection_info
    host node['postfixadmin']['database']['host']
    password node['postfixadmin']['database']['password']
    action :create
  end

  postgresql_database_user node['postfixadmin']['database']['user'] do
    connection postgresql_connection_info
    database_name node['postfixadmin']['database']['name']
    host node['postfixadmin']['database']['host']
    password node['postfixadmin']['database']['password']
    privileges [:all]
    action :grant
  end

  # Based on @phlipper work from:
  # https://github.com/phlipper/chef-postgresql
  language = 'plpgsql'
  dbname = node['postfixadmin']['database']['name']
  execute "createlang #{language} #{dbname}" do
    user 'postgres'
    not_if "psql -c 'SELECT lanname FROM pg_catalog.pg_language' #{dbname} \
      | grep '^ #{language}$'", user: 'postgres'
  end

else
  fail "Unknown database type: #{db_type}"
end

ark 'postfixadmin' do
  url node['postfixadmin']['url']
  version node['postfixadmin']['version']
  checksum node['postfixadmin']['checksum']
end

case node['postfixadmin']['web_server']
when 'apache'
  include_recipe 'postfixadmin::apache'
  web_group = node['apache']['group']
else
  web_group = nil
end

template 'config.local.php' do
  path "#{node['ark']['prefix_root']}/postfixadmin/config.local.php"
  source 'config.local.php.erb'
  owner 'root'
  group web_group
  mode '0640'
  variables(
    db_type: db_type,
    db_host: node['postfixadmin']['database']['host'],
    db_user: node['postfixadmin']['database']['user'],
    db_password: node['postfixadmin']['database']['password'],
    db_name: node['postfixadmin']['database']['name'],
    setup_password: node['postfixadmin']['setup_password_encrypted'],
    conf: node['postfixadmin']['conf']
  )
end
