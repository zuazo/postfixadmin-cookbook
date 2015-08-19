# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Recipe:: php_fpm
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

include_recipe 'php-fpm'

web_server = node['postfixadmin']['web_server']

# Fix PHP session error on CentOS:
# session_start(): open(/var/lib/php/session/..., O_RDWR) failed: No such file
# or directory (2)
directory '/var/lib/php/session' do
  owner node[web_server]['user']
  group node[web_server]['group']
  mode '00700'
  only_if { %w(centos).include?(node['platform']) }
end

php_fpm_pool node['postfixadmin']['php-fpm']['pool'] do
  user node[web_server]['user']
  group node[web_server]['group']
  listen_owner node[web_server]['user']
  listen_group node[web_server]['group']
  listen_mode '0660'
  # Fix php-fpm cookbook ubuntu support
  if node['platform'] == 'ubuntu' && node['platform_version'].to_i < 12
    process_manager 'dynamic'
  end
end
