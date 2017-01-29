# encoding: UTF-8
#
# Cookbook Name:: postfixadmin_test
# Attributes:: phantomjs
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2017 Xabier de Zuazo
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

# Issue: https://github.com/customink-webops/phantomjs/issues/30
default['phantomjs']['base_url'] =
  'https://bitbucket.org/ariya/phantomjs/downloads'
default['phantomjs']['version'] = '2.1.1'
default['phantomjs']['basename'] =
  "phantomjs-#{node['phantomjs']['version']}-linux-#{node['kernel']['machine']}"
