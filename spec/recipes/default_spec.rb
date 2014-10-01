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
  let(:chef_runner) do
    ChefSpec::Runner.new do |node|
      node.set['postfixadmin']['database']['name'] = db_name
      node.set['postfixadmin']['database']['user'] = db_user
      node.set['postfixadmin']['database']['password'] = db_password
      node.set['postfixadmin']['setup_password'] = setup_password
      node.set['postfixadmin']['setup_password_salt'] = setup_password_salt
      node.set['postgresql']['password']['postgres'] = db_password
    end
  end
  let(:chef_run) do
    chef_runner.converge(described_recipe)
  end
  before do
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
  end

  it 'should install the sequel gem' do
    expect(chef_run).to install_chef_gem('sequel')
  end

  it 'should include postfixadmin::mysql recipe' do
    expect(chef_run).to include_recipe('postfixadmin::mysql')
  end

  it 'should include database::mysql recipe' do
    expect(chef_run).to include_recipe('database::mysql')
  end

  it 'should create mysql database' do
    expect(chef_run).to create_mysql_database(db_name)
  end

  it 'should create mysql database user' do
    expect(chef_run).to grant_mysql_database_user(db_user)
      .with_database_name(db_name)
      .with_host('localhost')
      .with_password(db_password)
      .with_privileges([:all])
  end

  it 'should install postfixadmin' do
    expect(chef_run).to install_ark('postfixadmin')
  end

  it 'should include apache recipe' do
    expect(chef_run).to include_recipe('postfixadmin::apache')
  end

  it 'should create configuration file' do
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
      it "should install #{pkg} package" do
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
      it "should install #{pkg} package" do
        expect(chef_run).to install_package(pkg)
      end
    end

    it 'should not include yum-epel' do
      expect(chef_run).to_not include_recipe('yum-epel')
    end

  end # context on CentOS 5.10

  context 'on CentOS 6.5' do
    before do
      chef_runner.node.automatic['platform'] = 'centos'
      chef_runner.node.automatic['platform_version'] = '6.5'
    end

    %w(php-imap php-mbstring php-mysql).each do |pkg|
      it "should install #{pkg} package" do
        expect(chef_run).to install_package(pkg)
      end
    end

    it 'should not include yum-epel' do
      expect(chef_run).to_not include_recipe('yum-epel')
    end

  end # context on CentOS 6.5

  context 'on CentOS 7.0' do
    before do
      chef_runner.node.automatic['platform'] = 'centos'
      chef_runner.node.automatic['platform_version'] = '7.0'
    end

    it 'should include yum-epel' do
      expect(chef_run).to include_recipe('yum-epel')
    end

  end # context on CentOS 7.0

  context 'without Apache' do
    before do
      chef_runner.node.set['postfixadmin']['web_server'] = 'other'
    end

    it 'should not include apache recipe' do
      expect(chef_run).not_to include_recipe('postfixadmin::apache')
    end
  end

  context 'with PostgreSQL' do
    before do
      chef_runner.node.set['postfixadmin']['database']['type'] = 'postgresql'
    end

    it 'should include postfixadmin::postgresql recipe' do
      expect(chef_run).to include_recipe('postfixadmin::postgresql')
    end

    it 'should include database::postgresql recipe' do
      expect(chef_run).to include_recipe('database::postgresql')
    end

    it 'should create postgresql database' do
      expect(chef_run).to create_postgresql_database(db_name)
    end

    it 'should create postgresql database user' do
      expect(chef_run).to grant_postgresql_database_user(db_user)
        .with_database_name(db_name)
        .with_host('localhost')
        .with_password(db_password)
        .with_privileges([:all])
    end

    it 'should create plpgsql language' do
      expect(chef_run).to run_execute("createlang plpgsql #{db_name}")
        .with_user('postgres')
    end

    context 'on Ubuntu 12.04' do
      before do
        chef_runner.node.automatic['platform'] = 'ubuntu'
        chef_runner.node.automatic['platform_version'] = '12.04'
      end

      %w(php5-pgsql).each do |pkg|
        it "should install #{pkg} package" do
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
        it "should install #{pkg} package" do
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
        it "should install #{pkg} package" do
          expect(chef_run).to install_package(pkg)
        end
      end

    end # context on CentOS 6.5

  end

end
