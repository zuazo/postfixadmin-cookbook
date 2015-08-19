# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL.
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

describe 'postfixadmin::postgresql' do
  let(:db_password) { 'postfixadmin_pass' }
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['postgresql']['password']['postgres'] = db_password
    end.converge(described_recipe)
  end
  before do
    stub_command('ls /var/lib/postgresql/9.1/main/recovery.conf')
      .and_return(true)
  end

  it 'includes postgresql::server recipe' do
    expect(chef_run).to include_recipe('postgresql::server')
  end
end
