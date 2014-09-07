# encoding: UTF-8

def whyrun_supported?
  true
end

def alias_domain
  new_resource.alias_domain
end

def target_domain
  new_resource.target_domain
end

def active
  new_resource.active
end

def login_username
  new_resource.login_username
end

def login_password
  new_resource.login_password
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
  next if db.alias_domain_exist?(alias_domain)
  converge_by("Create #{new_resource}") do
    ruby_block "create alias domain #{alias_domain}" do
      block do
        result = PostfixAdmin::API.create_alias_domain(
          alias_domain, target_domain, active, login_username, login_password,
          ssl
        )
        Chef::Log.info("Created #{new_resource}: #{result}")
      end
      action :create
    end
  end
end
