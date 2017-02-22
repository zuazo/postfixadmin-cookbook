# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Provider:: mailbox
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2013-2015 Onddo Labs, SL.
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

def whyrun_supported?
  true
end

def mailbox
  new_resource.mailbox
end

def password
  new_resource.password
end

def active
  new_resource.active
end

def mail
  new_resource.mail
end

def login_username
  new_resource.login_username
end

def login_password
  new_resource.login_password
end

def db_type
  new_resource.db_type(
    if new_resource.db_type.nil?
      node['postfixadmin']['database']['type']
    else
      new_resource.db_type
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
      encrypted_attribute_read(%w(postfixadmin database password))
    else
      new_resource.db_password
    end
  )
end

def default_db_port
  case db_type
  when 'mysql'
    node['postfixadmin']['database']['port']
  when 'postgresql'
    node['postgresql']['config']['port']
  else
    raise "Port for \"#{db_type}\" type not known."
  end
end

def db_port
  new_resource.db_port(
    if new_resource.db_port.nil?
      default_db_port
    else
      new_resource.db_port
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

def port
  new_resource.port(
    if new_resource.port.nil?
      node['postfixadmin']['port']
    else
      new_resource.port
    end
  )
end

action :create do
  self.class.send(:include, Chef::EncryptedAttributesHelpers)
  @encrypted_attributes_enabled = node['postfixadmin']['encrypt_attributes']
  username, domain = mailbox.split('@', 2)
  if domain.nil?
    raise Chef::Exceptions::ArgumentError,
          'Could not get the domain name from the mailbox argument, it should '\
          'have the following format: user@domain.tld'
  end
  db = PostfixAdmin::DB.new(
    type: db_type, user: db_user, password: db_password, dbname: db_name,
    host: db_host, port: db_port
  )
  next if db.mailbox_exist?(mailbox)
  converge_by("Create #{new_resource}") do
    ruby_block "create mailbox #{mailbox}" do
      block do
        api = PostfixAdmin::API.new(ssl, port, login_username, login_password)
        result = api.create_mailbox(
          local_part: username, domain: domain, password: password,
          name: mailbox, active: active, welcome_mail: mail
        )
        Chef::Log.info("Created #{new_resource}: #{result}")
      end
      action :create
    end
  end
end
