# encoding: UTF-8

begin
  require 'sequel'
rescue LoadError
  Chef::Log.info("Missing gem 'sequel'")
end

module PostfixAdmin
  # A class to read PostfixAdmin data from its MySQL database
  class MySQL
    def initialize(user, password, dbname, host = '127.0.0.1', port = 3306)
      @user = user
      @password = password
      @dbname = dbname
      @host = host
      @port = port
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
      @db = Sequel.mysql(
        host: @host,
        user: @user,
        password: @password,
        database: @dbname
      ) if @db.nil?
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
