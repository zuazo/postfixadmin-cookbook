# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Provider:: admin
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

def user
  new_resource.user
end

def password
  new_resource.password
end

def setup_password
  new_resource.setup_password(
    if new_resource.setup_password.nil?
      encrypted_attribute_read(%w(postfixadmin setup_password))
    else
      new_resource.setup_password
    end
  )
end

def superadmin
  new_resource.superadmin
end

def domains
  [new_resource.superadmin].flatten
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
  api = PostfixadminCookbook::API.new(ssl, port, login_username, login_password)
  if login_username.nil? || login_password.nil?
    # Use setup.php to created the admin
    next if api.setup?(user, password)
    converge_by("Setup #{new_resource}") do
      ruby_block "setup admin user #{user}" do
        block do
          result = api.setup_admin(user, password, setup_password)
          Chef::Log.info("Created #{new_resource}: #{result}")
        end
        action :create
      end
    end
  else
    # Log in and create the admin
    next if api.admin_exist?(user)
    converge_by("Create #{new_resource}") do
      ruby_block "create admin #{user}" do
        block do
          result = api.create_admin(
            username: user, password: password, superadmin: superadmin,
            domain: domains, active: active
          )
          Chef::Log.info("Created #{new_resource}: #{result}")
        end
        action :create
      end
    end
  end
end

action :remove do
  self.class.send(:include, Chef::EncryptedAttributesHelpers)
  @encrypted_attributes_enabled = node['postfixadmin']['encrypt_attributes']
  converge_by("Create #{new_resource}") do
    raise 'postfixadmin_admin :remove action still not implemented.' # TODO
  end
end
