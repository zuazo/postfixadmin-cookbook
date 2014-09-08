# encoding: UTF-8

def whyrun_supported?
  true
end

def user
  new_resource.user
end

def password
  new_resource.password
end

def setup_password
  new_resource.setup_password(
    if new_resource.setup_password.nil?
      node['postfixadmin']['setup_password']
    else
      new_resource.setup_password
    end
  )
end

def db_user
  new_resource.db_user(
    if new_resource.db_user.nil?
      node['postfixadmin']['database']['user']
    else
      new_resource.db_user
    end
  )
end

def db_password
  new_resource.db_password(
    if new_resource.db_password.nil?
      node['postfixadmin']['database']['password']
    else
      new_resource.db_password
    end
  )
end

def db_name
  new_resource.db_name(
    if new_resource.db_name.nil?
      node['postfixadmin']['database']['name']
    else
      new_resource.db_name
    end
  )
end

def db_host
  new_resource.db_host(
    if new_resource.db_host.nil?
      node['postfixadmin']['database']['host']
    else
      new_resource.db_host
    end
  )
end

def ssl
  new_resource.ssl(
    if new_resource.ssl.nil?
      node['postfixadmin']['ssl']
    else
      new_resource.ssl
    end
  )
end

action :create do
  db = PostfixAdmin::MySQL.new(db_user, db_password, db_name, db_host)
  next if db.admin_exist?(user)
  converge_by("Create #{new_resource}") do
    ruby_block "create admin user #{user}" do
      block do
        api = PostfixAdmin::API.new(ssl)
        result = api.create_admin(user, password, setup_password)
        Chef::Log.info("Created #{new_resource}: #{result}")
      end
      action :create
    end
  end

end

action :remove do
  db = PostfixAdmin::MySQL.new(db_user, db_password, db_name, db_host)
  next unless db.admin_exist?(user)
  converge_by("Remove #{new_resource}") do
    ruby_block "remove admin user #{user}" do
      block do
        deleted = db.remove_admin(user)
        Chef::Log.info("Deleted #{new_resource}") if deleted
      end
      action :create
    end
  end
end
