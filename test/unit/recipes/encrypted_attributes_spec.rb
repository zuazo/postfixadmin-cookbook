# encoding: UTF-8
#
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

require_relative '../spec_helper'
require 'chef/encrypted_attributes'
require 'sequel'

describe 'postfixadmin encrypted attributes' do
  let(:step_into) do
    %w(
      postfixadmin_admin
      postfixadmin_alias
      postfixadmin_alias_domain
      postfixadmin_domain
      postfixadmin_mailbox
    )
  end
  let(:db_name) { 'postfixadmin_db' }
  let(:db_user) { 'postfixadmin_user' }
  let(:db_password) { 'postfixadmin_pass' }
  let(:setup_password) { 'postfixadmin_setup' }
  let(:setup_password_salt) { 'postfixadmin_setup_salt' }
  let(:chef_runner) { ChefSpec::SoloRunner.new(step_into: step_into) }
  let(:chef_run) { chef_runner.converge('postfixadmin_test::default') }
  let(:resources) { chef_runner.resources }
  let(:node) { chef_runner.node }
  before do
    node.set['postfixadmin']['database']['name'] = db_name
    node.set['postfixadmin']['database']['user'] = db_user

    stub_command('/usr/sbin/apache2 -t').and_return(true)
    allow(Sequel).to receive(:connect).and_return(
      Sequel.connect('mock://user:pass@host')
    )
  end

  shared_examples 'the "create admin user" ruby block' do
    let(:resource_name) { 'create admin user admin@admin.org' }
    let(:resource) { chef_run.ruby_block(resource_name) }

    it 'connects to the database' do
      expect(Sequel).to receive(:connect).with(
        "mysql2://#{db_user}:#{db_password}@127.0.0.1:/#{db_name}"
      )
      chef_run
    end

    it 'creates the admin user (issue #6)' do
      chef_run
      WebMock.disable_net_connect!
      stub_request(:post, 'http://127.0.0.1/setup.php')
        .with(
          body: {
            'fPassword' => 'p@ssw0rd1',
            'fPassword2' => 'p@ssw0rd1',
            'fUsername' => 'admin@admin.org',
            'form' => 'createadmin',
            'setup_password' => setup_password,
            'submit' => 'Add+Admin'
          }
        ).to_return(status: 200, body: 'ok', headers: {})
      resource.old_run_action(:create)
      WebMock.allow_net_connect!(net_http_connect_on_start: true)
    end
  end

  context 'with encrypted attributes enabled' do
    let(:chef_runner) { ChefSpec::ServerRunner.new(step_into: step_into) }
    before do
      node.set['postfixadmin']['encrypt_attributes'] = true
      node.set['postfixadmin']['database']['password'] =
        Chef::EncryptedAttribute.create(db_password)
      node.set['postfixadmin']['setup_password'] =
        Chef::EncryptedAttribute.create(setup_password)
      node.set['postfixadmin']['setup_password_salt'] =
        Chef::EncryptedAttribute.create(setup_password_salt)
    end

    it 'includes the encrypted_attributes recipe' do
      expect(chef_run).to include_recipe('encrypted_attributes')
    end

    it_behaves_like 'the "create admin user" ruby block'
  end

  context 'with encrypted attributes disabled' do
    before do
      node.set['postfixadmin']['encrypt_attributes'] = false
      node.set['postfixadmin']['database']['password'] = db_password
      node.set['postfixadmin']['setup_password'] = setup_password
      node.set['postfixadmin']['setup_password_salt'] = setup_password_salt
    end

    it 'does not include the encrypted_attributes recipe' do
      expect(chef_run).to_not include_recipe('encrypted_attributes')
    end

    it_behaves_like 'the "create admin user" ruby block'
  end
end
