# encoding: UTF-8
#
# Cookbook Name:: postfixadmin_test
# Recipe:: _postgresql
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2014-2015 Onddo Labs, SL. (www.onddo.com)
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

# Debian/Ubuntu requires locale cookbook:
# https://github.com/hw-cookbooks/postgresql/issues/108
ENV['LANGUAGE'] = ENV['LANG'] = node['locale']['lang']
ENV['LC_ALL'] = node['locale']['lang']
include_recipe 'locale'

include_recipe 'postfixadmin_test::_postgresql_memory'
node.default['postgresql']['password']['postgres'] = 'vagrant_postgres'
