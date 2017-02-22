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

describe PostfixAdmin::API, order: :random do
  let(:username) { 'User1' }
  let(:password) { '$up3rP@ss' }
  subject { described_class.new(false, 80, username, password) }
  let(:token_url) { '/edit.php?table=domain' }
  let(:token_sample) { 'edit_domain.html' }
  let(:token) { '6c2ef0d4187972393f047120f3fbc5f1' }
  let(:login_body) do
    {
      'fUsername' => username,
      'fPassword' => password,
      'lang' => 'en'
    }
  end
  before do
    WebMock.disable_net_connect!
    allow(Chef::Log).to receive(:fatal) # silence Chef errors
    reset_cookies

    # stub login:
    stub_request(:get, url('/login.php'))
      .to_return(body: sample('login.html'))
    stub_request(:post, url('/login.php'))
      .with(body: hash_including(login_body))
      .to_return(body: sample('login_ok.html'))
    # stub get token:
    stub_request(:get, url(token_url)).to_return(body: sample(token_sample))
  end
  after do
    WebMock.allow_net_connect!(net_http_connect_on_start: true)
  end

  describe '#create_admin' do
    let(:setup_password) { 's3tup_p4ssw0rd' }
    let(:body) do
      {
        'form' => 'createadmin',
        'username' => username,
        'password' => password,
        'password2' => password,
        'setup_password' => setup_password
      }
    end

    it 'parses successful creation' do
      stub_request(:post, url('/setup.php'))
        .with(body: hash_including(body))
        .to_return(body: sample('setup_ok.html'))
      subject.create_admin(username, password, 's3tup_p4ssw0rd')
    end

    it 'parses requirements error' do
      error = /Smarty template compile directory templates_c is not writable/
      stub_request(:post, url('/setup.php'))
        .with(body: hash_including(body))
        .to_return(body: sample('setup_requirement_error.html'))
      expect { subject.create_admin(username, password, 's3tup_p4ssw0rd') }
        .to raise_error(error)
    end

    it 'parses invalid email error' do
      error = 'Admin is not a valid email address!Email address'

      stub_request(:post, url('/setup.php'))
        .with(body: hash_including(body))
        .to_return(body: sample('setup_error_invalid_email.html'))
      expect { subject.create_admin(username, password, 's3tup_p4ssw0rd') }
        .to raise_error(error)
    end

    it 'parses invalid password error' do
      error = /Your password must contain at least 2 digit\(s\)/
      stub_request(:post, url('/setup.php'))
        .with(body: hash_including(body))
        .to_return(body: sample('setup_error_invalid_password.html'))
      expect { subject.create_admin(username, password, 's3tup_p4ssw0rd') }
        .to raise_error(error)
    end

    it 'handles unknown error' do
      error = /Unknown error during the setup of Postfix Admin/
      stub_request(:post, url('/setup.php'))
        .with(body: hash_including(body))
        .to_return(body: sample('setup_error_unknown.html'))
      expect { subject.create_admin(username, password, 's3tup_p4ssw0rd') }
        .to raise_error(error)
    end
  end # #create_admin

  describe '#create_domain' do
    let(:domain) { 'example.org' }
    let(:value_in) { { 'domain' => domain, 'key1' => 'value1' } }
    let(:value_out) { value_in }
    let(:body) do
      {
        'table' => 'domain',
        'value' => value_out,
        'token' => token
      }
    end

    it 'parses successful creation' do
      stub_request(:post, url('/edit.php?table=domain'))
        .with(body: hash_including(body))
        .to_return(body: sample('create_domain_ok.html'))
      subject.create_domain(value_in)
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
      { 'local_part' => mailbox, 'domain' => domain, 'key1' => 'value1' }
    end
    let(:value_out) do
      {
        'local_part' => mailbox,
        'domain' => domain,
        'key1' => 'value1',
        'active' => '0',
        'welcome_mail' => '0',
        'password2' => nil
      }
    end
    let(:body) do
      {
        'table' => 'mailbox',
        'value' => value_out,
        'token' => token
      }
    end

    it 'parses successful creation' do
      stub_request(:post, url('/edit.php?table=mailbox'))
        .with(body: hash_including(body))
        .to_return(body: sample('create_mailbox_ok.html'))
      subject.create_mailbox(value_in)
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
      { 'localpart' => calias, 'domain' => domain, 'goto' => 'value1' }
    end
    let(:value_out) do
      {
        'localpart' => calias,
        'domain' => domain,
        'goto' => 'value1',
        'active' => '0'
      }
    end
    let(:body) do
      {
        'table' => 'alias',
        'value' => value_out,
        'token' => token
      }
    end

    it 'parses successful creation' do
      stub_request(:post, url('/edit.php?table=alias'))
        .with(body: hash_including(body))
        .to_return(body: sample('create_alias_ok.html'))
      subject.create_alias(value_in)
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
      { 'alias_domain' => calias, 'target_domain' => domain }
    end
    let(:value_out) do
      {
        'alias_domain' => calias,
        'target_domain' => domain,
        'active' => '0'
      }
    end
    let(:body) do
      {
        'table' => 'aliasdomain',
        'value' => value_out,
        'token' => token
      }
    end

    it 'parses successful creation' do
      stub_request(:post, url('/edit.php?table=aliasdomain'))
        .with(body: hash_including(body))
        .to_return(body: sample('create_alias_domain_ok.html'))
      subject.create_alias_domain(value_in)
    end

    it 'parses requirements error' do
      error = /Invalid value given for target_domain/
      stub_request(:post, url('/edit.php?table=aliasdomain'))
        .with(body: hash_including(body))
        .to_return(body: sample('create_alias_domain_error.html'))
      expect { subject.create_alias_domain(value_in) }.to raise_error(error)
    end
  end # #create_alias_domain
end
