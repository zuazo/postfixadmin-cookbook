
begin
  require 'sequel'
rescue LoadError
  Chef::Log.info("Missing gem 'sequel'")
end

module PostfixAdmin
  class MySQL

    def initialize(user, password, dbname, host='127.0.0.1', port=3306)
      @user = user
      @password = password
      @dbname = dbname
      @host = host
      @port = port
      load_depends
    end

    def load_depends
      unless defined?(Sequel)
        Chef::Log.info("Trying to load 'sequel' at runtime.")
        Gem.clear_paths
        require 'sequel'
      end
    end

    def connect
      @db = Sequel.mysql(
        :host => @host,
        :user => @user,
        :password => @password,
        :database => @dbname
      )
    end

    def disconnect
      @db.disconnect
    end

    def adminExists?(user)
      connect
      if @db.table_exists?('admin')
        result = @db['SELECT 1 FROM admin WHERE username = ? LIMIT 1', user].count > 0
      else
        result = false
      end
      disconnect
      result
    end

    def removeAdmin(user)
      connect
      result = true
      if @db.table_exists?('admin')
        delete_ds = @db['DELETE FROM admin WHERE username = ?', user]
        result = delete_ds.delete > 0
      end
      if @db.table_exists?('domain_admins')
        delete_ds = @db['DELETE FROM domain_admins WHERE username = ?', user]
        delete_ds.delete
      end
      disconnect
      result
    end

    def domainExists?(domain)
      connect
      if @db.table_exists?('domain')
        result = @db['SELECT 1 FROM domain WHERE domain = ? LIMIT 1', domain].count > 0
      else
        result = false
      end
      disconnect
      result
    end

    def mailboxExists?(username)
      connect
      if @db.table_exists?('mailbox')
        result = @db['SELECT 1 FROM mailbox WHERE username = ? LIMIT 1', username].count > 0
      else
        result = false
      end
      disconnect
      result
    end

    def aliasExists?(address)
      connect
      if @db.table_exists?('alias')
        result = @db['SELECT 1 FROM alias WHERE address = ? LIMIT 1', address].count > 0
      else
        result = false
      end
      disconnect
      result
    end

  end
end

