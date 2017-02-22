# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Attributes:: default
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

default['postfixadmin']['version'] = '3.0.2'
default['postfixadmin']['url'] =
  'http://downloads.sourceforge.net/project/postfixadmin/postfixadmin/'\
  'postfixadmin-%{version}/postfixadmin-%{version}.tar.gz'
default['postfixadmin']['checksum'] =
  '9a4edb111258c90912aea66ad1dd684445b4f03f08f8549b9d708336ae019c8c'

default['postfixadmin']['port'] = nil # calculated
default['postfixadmin']['server_name'] = node['fqdn'] || 'postfixadmin.local'
default['postfixadmin']['server_aliases'] = []
default['postfixadmin']['headers'] = {}
default['postfixadmin']['ssl'] = false
default['postfixadmin']['encrypt_attributes'] = false
default['postfixadmin']['setup_password'] = nil # randomly generated
default['postfixadmin']['setup_password_salt'] = nil # required for chef-solo
default['postfixadmin']['setup_password_encrypted'] = nil # randomly generated

default['postfixadmin']['web_server'] = 'apache'

default['postfixadmin']['database']['manage'] = nil
default['postfixadmin']['database']['type'] = 'mysql'
default['postfixadmin']['database']['name'] = 'postfix'
default['postfixadmin']['database']['host'] = '127.0.0.1'
default['postfixadmin']['database']['user'] = 'postfix'
default['postfixadmin']['database']['password'] = nil # randomly generated

default['postfixadmin']['mysql']['instance'] = 'default'
default['postfixadmin']['mysql']['data_dir'] = nil
default['postfixadmin']['mysql']['port'] = '3306'
default['postfixadmin']['mysql']['run_group'] = nil
default['postfixadmin']['mysql']['run_user'] = nil
default['postfixadmin']['mysql']['version'] = nil
