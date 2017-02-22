# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2014-2015 Onddo Labs, SL.
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

require_relative '../spec_helper'

describe 'postfixadmin::mysql', order: :random do
  let(:mysql_service) { 'mysql_service_name' }
  let(:mysql_data_dir) { '/var/lib/mysql' }
  let(:mysql_run_group) { 'mysql_group' }
  let(:mysql_run_user) { 'mysql_user' }
  let(:mysql_version) { '5.7' }
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['postfixadmin']['mysql']['instance'] = mysql_service
      node.set['postfixadmin']['mysql']['data_dir'] = mysql_data_dir
      node.set['postfixadmin']['mysql']['run_group'] = mysql_run_group
      node.set['postfixadmin']['mysql']['run_user'] = mysql_run_user
      node.set['postfixadmin']['mysql']['version'] = mysql_version
    end.converge(described_recipe)
  end

  it 'does not include mysql::server recipe' do
    expect(chef_run).to_not include_recipe('mysql::server')
  end

  it 'installs mysql' do
    expect(chef_run).to create_mysql_service(mysql_service)
      .with_data_dir(mysql_data_dir)
      .with_run_group(mysql_run_group)
      .with_run_user(mysql_run_user)
      .with_version(mysql_version)
      .with_bind_address('127.0.0.1')
      .with_port('3306')
  end
end
