# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
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

name 'postfixadmin'
maintainer 'Xabier de Zuazo'
maintainer_email 'xabier@zuazo.org'
license 'Apache 2.0'
description 'Installs and configures PostfixAdmin, a web based interface used '\
            'to manage mailboxes, virtual domains and aliases.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '3.0.0'

if respond_to?(:source_url)
  source_url "https://github.com/zuazo/#{name}-cookbook"
end
if respond_to?(:issues_url)
  issues_url "https://github.com/zuazo/#{name}-cookbook/issues"
end

chef_version '>= 12.5' if respond_to?(:chef_version)

supports 'amazon'
supports 'debian'
supports 'centos'
supports 'fedora'
supports 'ubuntu'

depends 'apache2', '~> 3.0'
depends 'ark', '~> 2.2'
depends 'database', '~> 6.0'
depends 'encrypted_attributes', '~> 0.2'
depends 'mysql', '~> 8.0'
depends 'chef_nginx', '~> 5.0'
depends 'compat_resource', '>= 12.5'
depends 'openssl', '~> 6.0'
depends 'php', '~> 2.0'
depends 'php-fpm', '>= 0.7'
depends 'postgresql', '~> 6.0'
depends 'mysql2_chef_gem', '~> 1.0'
depends 'ssl_certificate', '~> 2.0'
depends 'yum-epel', '~> 0.5'

recipe 'postfixadmin::default', 'Installs and configures PostfixAdmin'
recipe 'postfixadmin::map_files',
       'Installs PostfixAdmin SQL map files to be used by Postfix'
recipe 'postfixadmin::mysql',
       'Installs MySQL server for PostfixAdmin'
recipe 'postfixadmin::postgresql',
       'Installs PostgreSQL server for PostfixAdmin'

provides 'postfixadmin_admin'
provides 'postfixadmin_alias'
provides 'postfixadmin_domain'
provides 'postfixadmin_mailbox'
provides 'postfixadmin_alias_domain'
# Commented until 11.0.10 server release (CHEF-3976)
# provides 'postfixadmin_admin[user]'
# provides 'postfixadmin_alias[address]'
# provides 'postfixadmin_domain[domain]'
# provides 'postfixadmin_mailbox[mailbox]'
# provides 'postfixadmin_alias_domain[alias_domain]'

attribute 'postfixadmin/version',
          display_name: 'postfixadmin version',
          description: 'PostfixAdmin version',
          type: 'string',
          required: 'optional',
          default: '3.0.2'

attribute 'postfixadmin/url',
          display_name: 'postfixadmin URL',
          description: 'PostfixAdmin download URL',
          calculated: true,
          type: 'string',
          required: 'optional'

attribute 'postfixadmin/checksum',
          display_name: 'postfixadmin checksum',
          description: 'PostfixAdmin download file checksum',
          type: 'string',
          required: 'optional',
          default:
            '761074e711ab618deda425dc013133b9d5968e0859bb883f10164061fd87006e'

attribute 'postfixadmin/port',
          display_name: 'postfixadmin port',
          description: 'PostfixAdmin listen port',
          calculated: true,
          type: 'string',
          required: 'optional'

attribute 'postfixadmin/server_name',
          display_name: 'server name',
          description: 'PostfixAdmin server name',
          calculated: true,
          type: 'string',
          required: 'recommended'

attribute 'postfixadmin/server_aliases',
          display_name: 'server aliases',
          description: 'PostfixAdmin server aliases',
          type: 'array',
          required: 'optional',
          default: []

attribute 'postfixadmin/headers',
          display_name: 'postfixadmin headers',
          description: 'PostfixAdmin HTTP headers to set as hash',
          type: 'hash',
          default: {}

attribute 'postfixadmin/ssl',
          display_name: 'enable ssl',
          description: 'enables HTTPS (with SSL)',
          choice: %w(true false),
          type: 'string',
          required: 'optional',
          default: 'false'

attribute 'postfixadmin/encrypt_attributes',
          display_name: 'postfixadmin encrypt attributes',
          description: 'Whether to encrypt PostfixAdmin attributes containing '\
            'credential secrets.',
          type: 'string',
          choice: %w(true false),
          default: 'false'

attribute 'postfixadmin/setup_password',
          display_name: 'postfixadmin setup_password',
          description: 'PostfixAdmin Setup Password (required for chef-solo)',
          calculated: true,
          type: 'string',
          required: 'optional'

attribute 'postfixadmin/setup_password_salt',
          display_name: 'postfixadmin password_salt',
          description: 'PostfixAdmin password salt (required for chef-solo)',
          calculated: true,
          type: 'string',
          required: 'optional'

attribute 'postfixadmin/setup_password_encrypted',
          display_name: 'postfixadmin password_encrypted',
          description: 'PostfixAdmin encrypted Password',
          calculated: true,
          type: 'string',
          required: 'optional'

attribute 'postfixadmin/web_server',
          display_name: 'Web Server',
          description: 'Web server to use: apache or false',
          choice: %w(apache nginx false),
          type: 'string',
          required: 'optional',
          default: 'apache'

attribute 'postfixadmin/database/manage',
          display_name: 'database manage',
          description: 'Whether to manage database creation.',
          calculated: true,
          type: 'string',
          required: 'optional'

attribute 'postfixadmin/database/type',
          display_name: 'database type',
          description: 'PostfixAdmin database type',
          choice: %w("mysql" "postgresql"),
          type: 'string',
          required: 'optional',
          default: '"mysql"'

attribute 'postfixadmin/database/name',
          display_name: 'database name',
          description: 'PostfixAdmin database name',
          type: 'string',
          required: 'optional',
          default: '"postfix"'

attribute 'postfixadmin/database/host',
          display_name: 'database host',
          description: 'PostfixAdmin database hostname or IP address',
          type: 'string',
          required: 'optional',
          default: '"127.0.0.1"'

attribute 'postfixadmin/database/user',
          display_name: 'database user',
          description: 'PostfixAdmin database login username',
          type: 'string',
          required: 'optional',
          default: '"postfix"'

attribute 'postfixadmin/database/password',
          display_name: 'database password',
          description:
            'PostfixAdmin database login password (required for chef-solo)',
          calculated: true,
          type: 'string',
          required: 'optional'

attribute 'postfixadmin/mysql/instance',
          display_name: 'mysql instance',
          description:
            'PostfixAdmin MySQL instance name to run by the mysql_service '\
            'LWRP from the mysql cookbook',
          type: 'string',
          required: 'optional',
          default: 'default'

attribute 'postfixadmin/mysql/data_dir',
          display_name: 'mysql data dir',
          description: 'PostfixAdmin MySQL data files path',
          type: 'string',
          required: 'optional',
          calcualted: true

attribute 'postfixadmin/mysql/port',
          display_name: 'mysql port',
          description: 'PostfixAdmin MySQL port',
          type: 'string',
          required: 'optional',
          default: '3306'

attribute 'postfixadmin/mysql/run_group',
          display_name: 'mysql run group',
          description: 'PostfixAdmin MySQL system group',
          type: 'string',
          required: 'optional',
          calculated: true

attribute 'postfixadmin/mysql/run_user',
          display_name: 'mysql run user',
          description: 'PostfixAdmin MySQL system user',
          type: 'string',
          required: 'optional',
          calculated: true

attribute 'postfixadmin/mysql/version',
          display_name: 'mysql version',
          description: 'PostfixAdmin MySQL version to install',
          type: 'string',
          required: 'optional',
          calculated: true

attribute 'postfixadmin/conf/encrypt',
          display_name: 'encryption configuration',
          description: 'The way do you want the passwords to be crypted',
          type: 'string',
          required: 'optional',
          default: '"md5crypt"'

attribute 'postfixadmin/conf/domain_path',
          display_name: 'domain path configuration',
          description: 'Whether you want to store the mailboxes per domain',
          choice: %w("YES" "NO"),
          type: 'string',
          required: 'optional',
          default: '"YES"'

attribute 'postfixadmin/conf/domain_in_mailbox',
          display_name: 'domain in mailbox configuration',
          description: 'Whether you want to have the domain in your mailbox',
          choice: %w("YES" "NO"),
          type: 'string',
          required: 'optional',
          default: '"NO"'

attribute 'postfixadmin/conf/fetchmail',
          display_name: 'enable fetchmail',
          description: 'Whether you want fetchmail tab',
          choice: %w("YES" "NO"),
          type: 'string',
          required: 'optional',
          default: '"NO"'

attribute 'postfixadmin/packages/requirements',
          display_name: 'postfixadmin packages requirements',
          description: 'PostfixAdmin required packages array',
          type: 'string',
          required: 'optional',
          calculated: true

attribute 'postfixadmin/packages/mysql',
          display_name: 'postfixadmin packages mysql',
          description: 'PostfixAdmin required packages array for MySQL support',
          type: 'string',
          required: 'optional',
          calculated: true

attribute 'postfixadmin/packages/postgresql',
          display_name: 'postfixadmin packages postgresql',
          description:
            'PostfixAdmin required packages array for PostgreSQL support',
          type: 'string',
          required: 'optional',
          calculated: true

attribute 'postfixadmin/mysql/server_root_password',
          display_name: 'postfixadmin mysql server root password',
          description: 'PostfixAdmin MySQL root password.',
          type: 'string',
          calculated: true

attribute 'postfixadmin/map_files/path',
          display_name: 'map files path',
          description: 'Path to generate map-files into',
          type: 'string',
          required: 'optional',
          default: '"/etc/postfix/tables"'

attribute 'postfixadmin/map_files/mode',
          display_name: 'map files mode',
          description: 'Map-files file-mode bits',
          type: 'string',
          required: 'optional',
          default: '00640'

attribute 'postfixadmin/map_files/owner',
          display_name: 'map files owner',
          description: 'Map-files files owner',
          type: 'string',
          required: 'optional',
          default: '"root"'

attribute 'postfixadmin/map_files/group',
          display_name: 'map files group',
          description: 'Map-files files group',
          type: 'string',
          required: 'optional',
          default: '"postfix"'

attribute 'postfixadmin/map_files/list',
          display_name: 'map files list',
          description: 'An array with map file names to generate',
          type: 'array',
          required: 'optional',
          default: [
            'db_virtual_alias_maps.cf',
            'db_virtual_alias_domain_maps.cf',
            'db_virtual_alias_domain_catchall_maps.cf',
            'db_virtual_domains_maps.cf',
            'db_virtual_mailbox_maps.cf',
            'db_virtual_alias_domain_mailbox_maps.cf',
            'db_virtual_mailbox_limit_maps.cf'
          ]

attribute 'postfixadmin/php-fpm/pool',
          display_name: 'postfixadmin php-fpm pool',
          description: 'PHP-FPM pool name to use with PostfixAdmin.',
          type: 'string',
          required: 'optional',
          default: 'postfixadmin'
