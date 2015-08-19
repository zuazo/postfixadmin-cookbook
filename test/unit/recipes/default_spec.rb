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

class Chef
  # make `Kernel#require` mockable
  class Recipe
    def require(string)
      Kernel.require(string)
    end
  end
end

describe 'postfixadmin::default' do
  let(:db_name) { 'postfixadmin_db' }
  let(:db_user) { 'postfixadmin_user' }
  let(:db_password) { 'postfixadmin_pass' }
  let(:setup_password) { 'postfixadmin_setup' }
  let(:setup_password_salt) { 'postfixadmin_setup_salt' }
  let(:chef_runner) { ChefSpec::SoloRunner.new }
  let(:chef_run) { chef_runner.converge(described_recipe) }
  let(:node) { chef_runner.node }
  before do
    node.set['postfixadmin']['database']['name'] = db_name
    node.set['postfixadmin']['database']['user'] = db_user
    node.set['postfixadmin']['database']['password'] = db_password
    node.set['postfixadmin']['setup_password'] = setup_password
    node.set['postfixadmin']['setup_password_salt'] = setup_password_salt
    node.set['postgresql']['password']['postgres'] = db_password

    allow(Kernel).to receive(:require).with('sequel')
    allow(Kernel).to receive(:require).with('openssl')
    allow(Kernel).to receive(:require).with('digest/md5')
    allow(Kernel).to receive(:require).with('digest/sha1')
    allow(Kernel).to receive(:require).with('pg')
    stub_command('/usr/sbin/apache2 -t').and_return(true)
    stub_command('/usr/sbin/httpd -t').and_return(true)
    stub_command(
      "psql -c 'SELECT lanname FROM pg_catalog.pg_language' #{db_name} "\
      "| grep '^ plpgsql$'"
    ).and_return(false)
    stub_command('which nginx').and_return(true)
    stub_command(
      'test -d /etc/php5/fpm/pool.d || mkdir -p /etc/php5/fpm/pool.d'
    ).and_return(true)
  end

  it 'installs the sequel gem' do
    expect(chef_run).to install_chef_gem('sequel')
  end

  it 'includes postfixadmin::mysql recipe' do
    expect(chef_run).to include_recipe('postfixadmin::mysql')
  end

  it 'does not include the database::mysql recipe' do
    expect(chef_run).to_not include_recipe('database::mysql')
  end

  it 'installs the mysql2_chef gem' do
    expect(chef_run).to install_mysql2_chef_gem('default')
  end

  it 'creates mysql database' do
    expect(chef_run).to create_mysql_database(db_name)
  end

  it 'creates mysql database user' do
    expect(chef_run).to grant_mysql_database_user(db_user)
      .with_database_name(db_name)
      .with_host('127.0.0.1')
      .with_password(db_password)
      .with_privileges([:all])
  end

  context 'with remote database' do
    before { node.set['postfixadmin']['database']['host'] = '1.2.3.4' }

    it 'does not include postfixadmin::mysql recipe' do
      expect(chef_run).to_not include_recipe('postfixadmin::mysql')
    end

    it 'does not install the mysql2_chef gem' do
      expect(chef_run).to_not install_mysql2_chef_gem('default')
    end

    it 'does not create mysql database' do
      expect(chef_run).to_not create_mysql_database(db_name)
    end

    it 'does not create mysql database user' do
      expect(chef_run).to_not grant_mysql_database_user(db_user)
    end
  end

  context 'without database management' do
    before { node.set['postfixadmin']['database']['manage'] = false }

    it 'does not include postfixadmin::mysql recipe' do
      expect(chef_run).to_not include_recipe('postfixadmin::mysql')
    end

    it 'does not install the mysql2_chef gem' do
      expect(chef_run).to_not install_mysql2_chef_gem('default')
    end

    it 'does not create mysql database' do
      expect(chef_run).to_not create_mysql_database(db_name)
    end

    it 'does not create mysql database user' do
      expect(chef_run).to_not grant_mysql_database_user(db_user)
    end
  end

  it 'installs postfixadmin' do
    expect(chef_run).to install_ark('postfixadmin')
  end

  it 'includes apache recipe' do
    expect(chef_run).to include_recipe('postfixadmin::apache')
  end

  context 'with nginx' do
    before { node.set['postfixadmin']['web_server'] = 'nginx' }

    it 'includes nginx recipe' do
      expect(chef_run).to include_recipe('postfixadmin::nginx')
    end

    it 'does not include apache recipe' do
      expect(chef_run).to_not include_recipe('postfixadmin::apache')
    end
  end

  it 'creates configuration file' do
    expect(chef_run).to create_template('config.local.php')
      .with_source('config.local.php.erb')
      .with_owner('root')
      .with_group('www-data')
      .with_mode('0640')
  end

  context 'on Ubuntu 12.04' do
    before do
      chef_runner.node.automatic['platform'] = 'ubuntu'
      chef_runner.node.automatic['platform_version'] = '12.04'
    end

    %w(php5-imap php5-mysql).each do |pkg|
      it "installs #{pkg} package" do
        expect(chef_run).to install_package(pkg)
      end
    end
  end # context on Ubuntu 12.04

  context 'on CentOS 5.10' do
    before do
      chef_runner.node.automatic['platform'] = 'centos'
      chef_runner.node.automatic['platform_version'] = '5.10'
    end

    %w(php53-imap php53-mbstring php53-mysql).each do |pkg|
      it "installs #{pkg} package" do
        expect(chef_run).to install_package(pkg)
      end
    end

    it 'does not include yum-epel' do
      expect(chef_run).to_not include_recipe('yum-epel')
    end
  end # context on CentOS 5.10

  context 'on CentOS 6.5' do
    before do
      chef_runner.node.automatic['platform'] = 'centos'
      chef_runner.node.automatic['platform_version'] = '6.5'
    end

    %w(php-imap php-mbstring php-mysql).each do |pkg|
      it "installs #{pkg} package" do
        expect(chef_run).to install_package(pkg)
      end
    end

    it 'does not include yum-epel' do
      expect(chef_run).to_not include_recipe('yum-epel')
    end
  end # context on CentOS 6.5

  context 'on CentOS 7.0' do
    before do
      chef_runner.node.automatic['platform'] = 'centos'
      chef_runner.node.automatic['platform_version'] = '7.0'
    end

    it 'includes yum-epel' do
      expect(chef_run).to include_recipe('yum-epel')
    end
  end # context on CentOS 7.0

  context 'without Apache' do
    before { chef_runner.node.set['postfixadmin']['web_server'] = 'other' }

    it 'does not include apache recipe' do
      expect(chef_run).not_to include_recipe('postfixadmin::apache')
    end
  end

  context 'with PostgreSQL' do
    before do
      stub_command('ls /var/lib/postgresql/8.4/main/recovery.conf')
        .and_return(true)
      stub_command('ls /var/lib/postgresql/9.1/main/recovery.conf')
        .and_return(true)
      chef_runner.node.set['postfixadmin']['database']['type'] = 'postgresql'
    end

    it 'includes postfixadmin::postgresql recipe' do
      expect(chef_run).to include_recipe('postfixadmin::postgresql')
    end

    it 'does not include the database::postgresql recipe' do
      expect(chef_run).to_not include_recipe('database::postgresql')
    end

    it 'includes postgresql::ruby recipe' do
      expect(chef_run).to include_recipe('postgresql::ruby')
    end

    it 'creates postgresql database' do
      expect(chef_run).to create_postgresql_database(db_name)
    end

    it 'creates postgresql database user' do
      expect(chef_run).to grant_postgresql_database_user(db_user)
        .with_database_name(db_name)
        .with_host('127.0.0.1')
        .with_password(db_password)
        .with_privileges([:all])
    end

    it 'creates plpgsql language' do
      expect(chef_run).to run_execute("createlang plpgsql #{db_name}")
        .with_user('postgres')
    end

    context 'on Ubuntu 12.04' do
      before do
        chef_runner.node.automatic['platform'] = 'ubuntu'
        chef_runner.node.automatic['platform_version'] = '12.04'
      end

      %w(php5-pgsql).each do |pkg|
        it "installs #{pkg} package" do
          expect(chef_run).to install_package(pkg)
        end
      end
    end # context on Ubuntu 12.04

    context 'on CentOS 5.10' do
      before do
        chef_runner.node.automatic['platform'] = 'centos'
        chef_runner.node.automatic['platform_version'] = '5.10'
      end

      %w(php53-pgsql).each do |pkg|
        it "installs #{pkg} package" do
          expect(chef_run).to install_package(pkg)
        end
      end
    end # context on CentOS 5.10

    context 'on CentOS 6.5' do
      before do
        chef_runner.node.automatic['platform'] = 'centos'
        chef_runner.node.automatic['platform_version'] = '6.5'
      end

      %w(php-pgsql).each do |pkg|
        it "installs #{pkg} package" do
          expect(chef_run).to install_package(pkg)
        end
      end
    end # context on CentOS 6.5
  end
end
