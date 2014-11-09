# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Library:: db
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2013 Onddo Labs, SL. (www.onddo.com)
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

begin
  require 'sequel'
rescue LoadError
  Chef::Log.info("Missing gem 'sequel'")
end

module PostfixAdmin
  # A class to read PostfixAdmin data from its MySQL database
  class DB
    DEFAULT_OPTIONS = {
      type: 'mysql',
      user: 'root',
      password: '',
      dbname: 'postfix',
      host: '127.0.0.1',
      port: 3306
    } unless defined?(::PostfixAdmin::DB::DEFAULT_OPTIONS)

    attr_reader :db

    def initialize(options)
      opts = DEFAULT_OPTIONS.merge(options)
      opts[:type] = opts[:type] == 'postgresql' ? 'postgres' : opts[:type]
      @uri =
        "#{opts[:type]}://#{opts[:user]}:#{opts[:password]}@"\
        "#{opts[:host]}:#{opts[:port]}/#{opts[:dbname]}"
      load_depends
    end

    def load_depends
      return if defined?(Sequel)
      Chef::Log.info("Trying to load 'sequel' at runtime.")
      Gem.clear_paths
      require 'sequel'
    end

    def setup_logging
      return unless Chef::Config[:log_level] == :debug
      @db.loggers << Chef::Log
      @db.sql_log_level = :debug
    end

    def connect
      return unless @db.nil?
      @db = Sequel.connect(@uri)
      setup_logging
    end

    def disconnect
      return if @db.nil?
      @db.disconnect
      @db = nil
    end

    def table_exist?(table)
      connect # ensure the connection
      @db.table_exists?(table)
    end

    def query_row_exist?(table, column, value)
      connect
      return false unless @db.table_exists?(table)
      !@db[table].select(column).where(column => value).first.nil?
    ensure
      disconnect
    end

    def query_delete_row(table, column, value)
      connect
      return false unless @db.table_exists?(table)
      @db[table].where(column => value).delete > 0
    ensure
      disconnect
    end

    def admin_exist?(user)
      query_row_exist?(:admin, :username, user)
    end

    def remove_domain_admins(user)
      query_delete_row(:domain_admins, :username, user)
    end

    def remove_admin(user)
      result_da = remove_domain_admins(user)
      return result_da unless table_exist?(:admin)
      query_delete_row(:admin, :username, user)
    end

    def domain_exist?(domain)
      query_row_exist?(:domain, :domain, domain)
    end

    def mailbox_exist?(username)
      query_row_exist?(:mailbox, :username, username)
    end

    def alias_exist?(address)
      query_row_exist?(:alias, :address, address)
    end

    def alias_domain_exist?(alias_domain)
      query_row_exist?(:alias_domain, :alias_domain, alias_domain)
    end
  end
end
