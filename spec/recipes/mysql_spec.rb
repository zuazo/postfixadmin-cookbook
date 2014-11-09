# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL. (www.onddo.com)
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

require 'spec_helper'

describe 'postfixadmin::mysql' do
  let(:mysql_service) { 'mysql_service_name' }
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['mysql']['service_name'] = mysql_service
    end.converge(described_recipe)
  end

  it 'does not include mysql::server recipe' do
    expect(chef_run).to_not include_recipe('mysql::server')
  end

  it 'installs mysql' do
    expect(chef_run).to create_mysql_service(mysql_service)
  end

end
