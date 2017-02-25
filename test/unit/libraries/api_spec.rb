# encoding: UTF-8
#
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

require_relative '../spec_helper'
require 'api'

describe PostfixadminCookbook::API, order: :random do
  let(:username) { 'User1' }
  let(:password) { '$up3rP@ss' }
  subject { described_class.new(false, 80, username, password) }
  let(:token_sample) { 'edit_domain.html' }
  let(:token) { '6c2ef0d4187972393f047120f3fbc5f1' }
  let(:login_body) do
    {
      fUsername: username,
      fPassword: password,
      lang: 'en'
    }
  end
  before do
    WebMock.disable_net_connect!
    allow(Chef::Log).to receive(:fatal) # silence Chef errors
    reset_cookies

    stub_postfixadmin_login
    stub_request(:post, url('/login.php'))
      .with(body: hash_including(login_body))
      .to_return(body: sample('login_ok.html'))
  end
  after do
    WebMock.allow_net_connect!(net_http_connect_on_start: true)
  end

  describe '#load_depends' do
    before do
      allow(Chef::Log).to receive(:info)
      hide_const('Addressable')
    end
    after { subject.load_depends }

    it 'requires addressable' do
      expect(subject).to receive('require').with('addressable').once
    end
  end

  shared_examples 'a table value checker that' do |meth, fields|
    table = meth.delete('_')
    let(:path) { "/list.php?table=#{table}&output=csv" }
    let(:file) { "#{table}.csv" }
    before do
      stub_request(:get, url(path)).to_return(body: sample(file))
    end

    it 'returns no error for an existing value' do
      first = [fields[:true]].flatten.first
      pending if first.nil?
      subject.send("#{meth}_exist?", first)
    end

    it 'returns no error for a non-existing value' do
      first = [fields[:false]].flatten.first
      pending if first.nil?
      subject.send("#{meth}_exist?", first)
    end

    [fields[:true]].flatten.each do |value|
      it "returns true for the #{value.inspect} value" do
        expect(subject.send("#{meth}_exist?", value)).to eq(true)
      end
    end

    [fields[:false]].flatten.each do |value|
      it "returns false for the #{value.inspect} value" do
        expect(subject.send("#{meth}_exist?", value)).to eq(false)
      end
    end
  end

  describe '#admin_exist?' do
    it_behaves_like(
      'a table value checker that', 'admin',
      true: 'admin@admin.org', false: 'bademail@foobar.com'
    )
  end

  describe '#domain_exist?' do
    it_behaves_like(
      'a table value checker that', 'domain',
      true: %w(foo.com bar.com), false: 'foobar.com'
    )
  end

  describe '#mailbox_exist?' do
    it_behaves_like(
      'a table value checker that', 'mailbox',
      true: 'postmaster@foobar.com', false: 'non.existing@foobar.com'
    )
  end

  describe '#alias_exist?' do
    it_behaves_like(
      'a table value checker that', 'alias',
      true: 'admin@foobar.com', false: 'non.existing@foobar.com'
    )
  end

  describe '#alias_domain_exist?' do
    it_behaves_like(
      'a table value checker that', 'alias_domain',
      true: 'example.com', false: 'non-existing.com'
    )
  end

  describe '#setup?' do
    let(:login_body) { { fUsername: username, fPassword: password } }

    describe 'when the admin does not exist' do
      before do
        stub_request(:post, url('/login.php'))
          .with(body: hash_including(login_body))
          .to_return(body: sample('login_error.html'))
        stub_request(:get, token_url)
          .to_return(body: 'login_error.html')
      end

      it 'returns false' do
        expect(subject.setup?(username, password)).to eq(false)
      end
    end

    describe 'when the admin exist' do
      before do
        stub_request(:post, url('/login.php'))
          .with(body: hash_including(login_body))
          .to_return(body: sample('login_ok.html'))
        stub_request(:get, token_url)
          .to_return(body: sample('edit_domain.html'))
      end

      it 'returns true' do
        expect(subject.setup?(username, password)).to eq(true)
      end
    end
  end

  describe '#setup_admin' do
    let(:setup_password) { 's3tup_p4ssw0rd' }
    let(:body) do
      {
        form: 'createadmin',
        username: username,
        password: password,
        password2: password,
        setup_password: setup_password
      }
    end

    it 'parses successful creation' do
      stub =
        stub_request(:post, url('/setup.php'))
        .with(body: hash_including(body))
        .to_return(body: sample('setup_ok.html'))
      subject.setup_admin(username, password, 's3tup_p4ssw0rd')
      expect(stub).to have_been_requested
    end

    it 'parses requirements error' do
      error = /Smarty template compile directory templates_c is not writable/
      stub_request(:post, url('/setup.php'))
        .with(body: hash_including(body))
        .to_return(body: sample('setup_requirement_error.html'))
      expect { subject.setup_admin(username, password, 's3tup_p4ssw0rd') }
        .to raise_error(error)
    end

    it 'parses invalid email error' do
      error = 'Admin is not a valid email address!Email address'

      stub =
        stub_request(:post, url('/setup.php'))
        .with(body: hash_including(body))
        .to_return(body: sample('setup_error_invalid_email.html'))
      expect { subject.setup_admin(username, password, 's3tup_p4ssw0rd') }
        .to raise_error(error)
      expect(stub).to have_been_requested
    end

    it 'parses invalid password error' do
      error = /Your password must contain at least 2 digit\(s\)/
      stub =
        stub_request(:post, url('/setup.php'))
        .with(body: hash_including(body))
        .to_return(body: sample('setup_error_invalid_password.html'))
      expect { subject.setup_admin(username, password, 's3tup_p4ssw0rd') }
        .to raise_error(error)
      expect(stub).to have_been_requested
    end

    it 'handles unknown error' do
      error = /Unknown error during the setup of Postfix Admin/
      stub_request(:post, url('/setup.php'))
        .with(body: hash_including(body))
        .to_return(body: sample('setup_error_unknown.html'))
      expect { subject.setup_admin(username, password, 's3tup_p4ssw0rd') }
        .to raise_error(error)
    end
  end # #setup_admin

  describe '#create_admin' do
    let(:domain) { 'example.org' }
    let(:value_in) do
      {
        username: 'user1',
        password: 'pass1',
        superadmin: true,
        active: true,
        key1: 'value1'
      }
    end
    let(:value_out) do
      {
        username: 'user1',
        password: 'pass1',
        password2: 'pass1',
        superadmin: '1',
        active: '1',
        key1: 'value1'
      }
    end
    let(:body) do
      {
        table: 'admin',
        value: value_out,
        token: token
      }
    end

    it 'parses successful creation' do
      stub =
        stub_request(:post, url('/edit.php?table=admin'))
        .with(body: hash_including(body))
        .to_return(body: sample('create_admin_ok.html'))
      subject.create_admin(value_in)
      expect(stub).to have_been_requested
    end

    it 'parses requirements error' do
      error = /Admin is not a valid email address/
      stub_request(:post, url('/edit.php?table=admin'))
        .with(body: hash_including(body))
        .to_return(body: sample('create_admin_error.html'))
      expect { subject.create_admin(value_in) }.to raise_error(error)
    end

    it 'supports domain array list' do
      value_in[:domain] = %w(mydomain.org)
      body[:value]['domain'] = %w(mydomain.org)

      stub =
        stub_request(:post, url('/edit.php?table=admin'))
        .with(body: hash_including(body))
        .to_return(body: sample('create_admin_ok.html'))
      subject.create_admin(value_in)
      expect(stub).to have_been_requested
    end
  end # #create_admin

  describe '#create_domain' do
    let(:domain) { 'example.org' }
    let(:value_in) { { domain: domain, key1: 'value1' } }
    let(:value_out) { value_in }
    let(:body) do
      {
        table: 'domain',
        value: value_out,
        token: token
      }
    end

    it 'parses successful creation' do
      stub =
        stub_request(:post, url('/edit.php?table=domain'))
        .with(body: hash_including(body))
        .to_return(body: sample('create_domain_ok.html'))
      subject.create_domain(value_in)
      expect(stub).to have_been_requested
    end

    it 'parses requirements error' do
      error = /Invalid domain name .*, fails regexp check/
      stub_request(:post, url('/edit.php?table=domain'))
        .with(body: hash_including(body))
        .to_return(body: sample('create_domain_error.html'))
      expect { subject.create_domain(value_in) }.to raise_error(error)
    end
  end # #create_domain

  describe '#create_mailbox' do
    let(:domain) { 'example.org' }
    let(:mailbox) { 'user1' }
    let(:value_in) do
      {
        local_part: mailbox,
        domain: domain,
        password: 'p4ssw0rd',
        key1: 'value1',
        active: false,
        welcome_mail: false
      }
    end
    let(:value_out) do
      {
        local_part: mailbox,
        domain: domain,
        password: 'p4ssw0rd',
        password2: 'p4ssw0rd',
        key1: 'value1',
        active: '0',
        welcome_mail: '0'
      }
    end
    let(:body) do
      {
        table: 'mailbox',
        value: value_out,
        token: token
      }
    end

    it 'parses successful creation' do
      stub =
        stub_request(:post, url('/edit.php?table=mailbox'))
        .with(body: hash_including(body))
        .to_return(body: sample('create_mailbox_ok.html'))
      subject.create_mailbox(value_in)
      expect(stub).to have_been_requested
    end

    it 'parses requirements error' do
      error = /Password is too short.* requires 5 characters/
      stub_request(:post, url('/edit.php?table=mailbox'))
        .with(body: hash_including(body))
        .to_return(body: sample('create_mailbox_error.html'))
      expect { subject.create_mailbox(value_in) }.to raise_error(error)
    end
  end # #create_mailbox

  describe '#create_alias' do
    let(:domain) { 'example.org' }
    let(:calias) { 'alias1' }
    let(:value_in) do
      {
        localpart: calias,
        domain: domain,
        goto: 'value1',
        active: true
      }
    end
    let(:value_out) do
      {
        localpart: calias,
        domain: domain,
        goto: 'value1',
        active: '1'
      }
    end
    let(:body) do
      {
        table: 'alias',
        value: value_out,
        token: token
      }
    end

    it 'parses successful creation' do
      stub =
        stub_request(:post, url('/edit.php?table=alias'))
        .with(body: hash_including(body))
        .to_return(body: sample('create_alias_ok.html'))
      subject.create_alias(value_in)
      expect(stub).to have_been_requested
    end

    it 'parses requirements error' do
      error = /Bad Alias: Invalid email address .*, fails regexp check/
      stub_request(:post, url('/edit.php?table=alias'))
        .with(body: hash_including(body))
        .to_return(body: sample('create_alias_error.html'))
      expect { subject.create_alias(value_in) }.to raise_error(error)
    end
  end # #create_alias

  describe '#create_alias_domain' do
    let(:domain) { 'example.org' }
    let(:calias) { 'alias1' }
    let(:value_in) do
      { alias_domain: calias, target_domain: domain }
    end
    let(:value_out) do
      {
        alias_domain: calias,
        target_domain: domain
      }
    end
    let(:body) do
      {
        table: 'aliasdomain',
        value: value_out,
        token: token
      }
    end

    it 'parses successful creation' do
      stub =
        stub_request(:post, url('/edit.php?table=aliasdomain'))
        .with(body: hash_including(body))
        .to_return(body: sample('create_alias_domain_ok.html'))
      subject.create_alias_domain(value_in)
      expect(stub).to have_been_requested
    end

    it 'parses requirements error' do
      error = /Invalid value given for target_domain/
      stub_request(:post, url('/edit.php?table=aliasdomain'))
        .with(body: hash_including(body))
        .to_return(body: sample('create_alias_domain_error.html'))
      expect { subject.create_alias_domain(value_in) }.to raise_error(error)
    end
  end # #create_alias_domain

  %w(admin domain mailbox alias alias_domain).each do |resource|
    table = resource.delete('_')

    describe "#delete_#{resource}" do
      before { force_token(token) }

      it 'parses successful creation' do
        stub =
          stub_request(:get, %r{/delete\.php})
          .to_return(body: sample('delete_admin_ok.html'))
        subject.send("delete_#{resource}", 'value')
        expect(stub).to have_been_requested
      end

      it 'adds table value to the query' do
        stub =
          stub_request(:get, %r{/delete\.php.*[&\?]table=#{table}})
          .to_return(body: sample('delete_admin_ok.html'))
        subject.send("delete_#{resource}", 'value')
        expect(stub).to have_been_requested
      end

      it 'adds delete value to the query' do
        stub =
          stub_request(:get, %r{/delete\.php.*[&\?]delete=value})
          .to_return(body: sample('delete_admin_ok.html'))
        subject.send("delete_#{resource}", 'value')
        expect(stub).to have_been_requested
      end

      it 'adds token value to the query' do
        stub =
          stub_request(:get, %r{/delete\.php.*[&\?]token=#{token}})
          .to_return(body: sample('delete_admin_ok.html'))
        subject.send("delete_#{resource}", 'value')
        expect(stub).to have_been_requested
      end

      it 'parses requirements error' do
        error = /The admin does not exist!/
        stub_request(:get, %r{/delete\.php})
          .to_return(body: sample('delete_admin_error.html'))
        expect { subject.send("delete_#{resource}", 'value') }
          .to raise_error(error)
      end
    end
  end
end
