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
require 'api_http'

describe PostfixadminCookbook::API::HTTP, order: :random do
  let(:username) { 'User1' }
  let(:password) { '$up3rP@ss' }
  subject { described_class.new(username, password) }
  let(:token_sample) { 'edit_domain.html' }
  before do
    WebMock.disable_net_connect!
    allow(Chef::Log).to receive(:fatal) # silence Chef errors
    reset_cookies
  end
  after do
    WebMock.allow_net_connect!(net_http_connect_on_start: true)
  end

  describe '.get_token' do
    let(:path) { '/edit.php?table=domain' }
    let(:token) { '6c2ef0d4187972393f047120f3fbc5f1' }
    before do
      stub_request(:get, url(path)).to_return(body: sample('edit_domain.html'))
    end

    it 'returns the token' do
      expect(described_class.get_token(path)).to eq(token)
    end
  end # .get_token

  describe '#setup' do
    let(:path) { '/setup.php' }
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

    it 'sets up' do
      stub_request(:post, url(path))
        .with(body: hash_including(body))
        .to_return(body: sample('setup_ok.html'))
      subject.setup(username, password, setup_password)
    end
  end # #setup

  describe '#login' do
    let(:cookie) { 'RANDOM_COOKIE_1idj3' }
    let(:body) do
      {
        'fUsername' => username,
        'fPassword' => password,
        'lang' => 'en'
      }
    end

    it 'parses successful log in' do
      # stub login:
      stub_request(:get, url('/login.php'))
        .to_return(
          headers: { 'Set-Cookie' => cookie },
          body: sample('login.html')
        )
      stub_request(:post, url('/login.php'))
        .with(
          headers: { 'Cookie' => cookie },
          body: hash_including(body)
        ).to_return(body: sample('login_ok.html'))
      # stub get token:
      stub_request(:get, token_url).to_return(body: sample(token_sample))
      subject.login
    end
  end # #login

  describe '#get' do
    let(:path) { '/myurl' }
    let(:cookie) { 'RANDOM_COOKIE_1idj3' }
    before { allow(subject).to receive(:login) }

    it 'logs in' do
      stub_request(:get, url(path)).to_return(body: sample('login.html'))
      expect(subject).to receive(:login).once
      subject.get(path)
    end

    it 'gets url' do
      force_cookie(cookie)
      stub_request(:get, url(path))
        .with(headers: { 'Cookie' => cookie })
        .to_return(body: sample('login.html'))
      subject.get(path)
    end
  end # #get

  describe '#post' do
    let(:path) { '/myurl' }
    let(:cookie) { 'RANDOM_COOKIE_1idj3' }
    let(:token) { '6c2ef0d4187972393f047120f3fbc5f1' }
    let(:body) { { 'key1' => 'value1', 'key2' => 'value2' } }
    before { allow(subject).to receive(:login) }

    it 'logs in' do
      stub_request(:post, url(path)).to_return(body: sample('login.html'))
      expect(subject).to receive(:login).once
      subject.post(path, body)
    end

    it 'posts url' do
      force_cookie(cookie)
      force_token(token)
      stub_request(:post, url(path))
        .with(
          body: body.merge('token' => token),
          headers: { 'Cookie' => cookie }
        )
        .to_return(body: sample('login.html'))
      subject.post(path, body)
    end
  end # #post

  context 'with SSL and custom port' do
    let(:port) { 4040 }
    let(:path) { '/mypath' }
    subject { described_class.new(username, password, true, port) }
    before { allow(subject).to receive(:login) }

    it 'uses https' do
      stub_request(:get, "https://127.0.0.1:#{port}#{path}")
        .to_return(body: sample('setup_ok.html'))
      subject.get(path)
    end
  end
end
