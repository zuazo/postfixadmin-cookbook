# encoding: UTF-8
#
# Cookbook Name:: postfixadmin_test
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

# Debian/Ubuntu requires locale cookbook:
# https://github.com/hw-cookbooks/postgresql/issues/108
ENV['LANGUAGE'] = ENV['LANG'] = node['locale']['lang']
ENV['LC_ALL'] = node['locale']['lang']
include_recipe 'locale'

node.default['mysql']['server_root_password'] = 'vagrant_root'
node.default['mysql']['server_debian_password'] = 'vagrant_debian'
node.default['mysql']['server_repl_password'] = 'vagrant_repl'

node.default['postfixadmin']['database']['password'] = 'postfix_pass'
node.default['postfixadmin']['setup_password'] = 'admin'
node.default['postfixadmin']['setup_password_salt'] = 'salt'

include_recipe 'postfixadmin'

package 'lsof' # requried for integration tests
package 'curl' # requried for integration tests
