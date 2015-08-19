# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Attributes:: map_files
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2013 Onddo Labs, SL.
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

default['postfixadmin']['map_files']['path'] = '/etc/postfix/tables'
default['postfixadmin']['map_files']['mode'] = '00640'
default['postfixadmin']['map_files']['owner'] = 'root'
default['postfixadmin']['map_files']['group'] = 'postfix'

default['postfixadmin']['map_files']['list'] = %w(
  db_virtual_alias_maps.cf
  db_virtual_alias_domain_maps.cf
  db_virtual_alias_domain_catchall_maps.cf
  db_virtual_domains_maps.cf
  db_virtual_mailbox_maps.cf
  db_virtual_alias_domain_mailbox_maps.cf
  db_virtual_mailbox_limit_maps.cf
)
