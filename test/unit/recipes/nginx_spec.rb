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

describe 'postfixadmin::nginx', order: :random do
  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['postfixadmin']['ssl'] = true
    end.converge(described_recipe)
  end
  before do
    stub_command('which nginx').and_return(true)
    stub_command(
      'test -d /etc/php5/fpm/pool.d || mkdir -p /etc/php5/fpm/pool.d'
    ).and_return(true)
    allow(::File).to receive(:symlink?).and_call_original
    allow(::File).to receive(:exist?).and_call_original
    allow(::File).to receive(:exist?).with('/etc/init.d/apache2')
      .and_return(true)
  end

  it 'includes chef_nginx recipe' do
    expect(chef_run).to include_recipe('chef_nginx')
  end

  it 'includes postfixadmin::php_fpm recipe' do
    expect(chef_run).to include_recipe('postfixadmin::php_fpm')
  end

  it 'creates ssl certificate' do
    expect(chef_run).to create_ssl_certificate('postfixadmin')
  end

  it 'stops apache2 service' do
    expect(chef_run).to stop_service('apache2')
  end

  it 'disables apache2 service' do
    expect(chef_run).to disable_service('apache2')
  end

  context 'ssl certificate resource' do
    let(:resource) { chef_run.ssl_certificate('postfixadmin') }

    it 'notifies nginx restart' do
      expect(resource).to notify('service[nginx]').to(:restart).delayed
    end
  end

  it 'disables nginx default site' do
    expect(chef_run).to disable_nginx_site('default')
  end

  it 'creates postfixadmin virtualhost' do
    expect(chef_run)
      .to create_template('/etc/nginx/sites-available/postfixadmin')
      .with_source('nginx_vhost.erb')
      .with_mode(00644)
      .with_owner('root')
      .with_group('root')
  end

  context 'postfixadmin virtualhost resource' do
    let(:resource) do
      chef_run.template('/etc/nginx/sites-available/postfixadmin')
    end

    it 'notifies nginx to reload' do
      expect(resource).to notify('service[nginx]').to(:reload).delayed
    end
  end

  it 'enables nginx postfixadmin site' do
    expect(chef_run).to enable_nginx_site('postfixadmin')
  end

  context 'postfixadmin nginx_site resource' do
    let(:resource) do
      chef_run.nginx_site('postfixadmin')
    end

    it 'notifies nginx to restart' do
      expect(resource).to notify('service[nginx]').to(:restart).immediately
    end

    it 'php-fpm nginx to restart' do
      expect(resource).to notify('service[php-fpm]').to(:restart).immediately
    end
  end
end
