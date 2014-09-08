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

    def connect
      @db = Sequel.mysql(
        host: @host,
        user: @user,
        password: @password,
        database: @dbname
      )
    end

    def disconnect
      @db.disconnect
    end

    def admin_exist?(user)
      connect
      return false unless @db.table_exists?('admin')
      @db['SELECT 1 FROM admin WHERE username = ? LIMIT 1', user].count > 0
    ensure
      disconnect
    end

    def remove_domain_admins(user)
      connect
      return false unless @db.table_exists?('domain_admins')
      @db['DELETE FROM domain_admins WHERE username = ?', user].delete > 0
    ensure
      disconnect
    end

    def remove_admin(user)
      result_da = remove_domain_admins(user)
      connect
      return result_da unless @db.table_exists?('admin')
      @db['DELETE FROM admin WHERE username = ?', user].delete > 0
    ensure
      disconnect
    end

    def domain_exist?(domain)
      connect
      return false unless @db.table_exists?('domain')
      @db['SELECT 1 FROM domain WHERE domain = ? LIMIT 1', domain].count > 0
    ensure
      disconnect
    end

    def mailbox_exist?(username)
      connect
      return false unless @db.table_exists?('mailbox')
      @db['SELECT 1 FROM mailbox WHERE username = ? LIMIT 1', username]
        .count > 0
    ensure
      disconnect
    end

    def alias_exist?(address)
      connect
      return false unless @db.table_exists?('alias')
      @db['SELECT 1 FROM alias WHERE address = ? LIMIT 1', address].count > 0
    ensure
      disconnect
    end

    def alias_domain_exist?(alias_domain)
      connect
      return false unless @db.table_exists?('alias_domain')
      @db[
        'SELECT 1 FROM alias_domain WHERE alias_domain = ? LIMIT 1',
        alias_domain
      ].count > 0
    ensure
      disconnect
    end
  end
end
