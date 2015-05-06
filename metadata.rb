# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2013-2015 Onddo Labs, SL. (www.onddo.com)
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
maintainer 'Onddo Labs, Sl.'
maintainer_email 'team@onddo.com'
license 'Apache 2.0'
description 'Installs and configures PostfixAdmin, a web based interface used '\
            'to manage mailboxes, virtual domains and aliases.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '1.4.1'

supports 'amazon'
supports 'debian'
supports 'centos'
supports 'fedora'
supports 'ubuntu'

depends 'apache2', '~> 3.0'
depends 'ark', '~> 0.9'
depends 'database', '>= 2.3.1'
depends 'encrypted_attributes', '~> 0.2'
depends 'mysql', '~> 5.0'
depends 'nginx', '~> 2.7'
depends 'php', '~> 1.5'
depends 'php-fpm', '>= 0.7'
depends 'postgresql', '~> 3.4'
depends 'mysql2_chef_gem', '~> 1.0'
depends 'ssl_certificate', '~> 1.1'
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
          default: '2.3.7'

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

grouping 'postfixadmin/database',
         title: 'postfixadmin database',
         description: 'PostfixAdmin database configuration options'

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
          default: '"localhost"'

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

grouping 'postfixadmin/conf',
         title: 'postfixadmin configuration',
         description: 'PostfixAdmin configuration options (config.local.php)'

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

grouping 'postfixadmin/packages',
         title: 'postfixadmin packages',
         description: 'PostfixAdmin required packages'

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

grouping 'postfixadmin/mysql',
         title: 'postfixadmin mysql',
         description: 'PostfixAdmin MySQL server credentials'

attribute 'postfixadmin/mysql/server_root_password',
          display_name: 'postfixadmin mysql server root password',
          description: 'PostfixAdmin MySQL root password.',
          type: 'string',
          calculated: true

attribute 'postfixadmin/mysql/server_debian_password',
          display_name: 'postfixadmin mysql server debian password',
          description: 'PostfixAdmin MySQL debian user password.',
          type: 'string',
          calculated: true

attribute 'postfixadmin/mysql/server_repl_password',
          display_name: 'postfixadmin mysql server repl password',
          description: 'PostfixAdmin MySQL repl user password.',
          type: 'string',
          calculated: true

grouping 'postfixadmin/map_files',
         title: 'postfixadmin map files',
         description: 'PostfixAdmin map-files configuration options'

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
