# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Resource:: admin
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2017 Xabier de Zuazo
# Copyright:: Copyright (c) 2013 Onddo Labs, SL.
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

default_action :create

property :user, String, name_property: true
property :password, String, sensitive: true
property :setup_password, String, sensitive: true
property :superadmin, [TrueClass, FalseClass], default: true
property :domains, [Array, String], default: []
property :active, [TrueClass, FalseClass], default: true
property :login_username, String
property :login_password, String, sensitive: true
property :ssl, [TrueClass, FalseClass], default: lazy { default_ssl }
property :port, [Integer, String, NilClass], default: lazy { default_port }

include PostfixadminCookbook::ResourceHelpers

action :create do
  self.class.send(:include, Chef::EncryptedAttributesHelpers)
  @encrypted_attributes_enabled = node['postfixadmin']['encrypt_attributes']

  if setup_password.nil?
    setup_password(encrypted_attribute_read(%w(postfixadmin setup_password)))
  end

  api = PostfixadminCookbook::API.new(ssl, port, login_username, login_password)
  if login_username.nil? || login_password.nil?
    # Use setup.php to created the admin
    next if api.setup?(user, password)
    converge_by("Setup #{new_resource}") do
      ruby_block "setup admin user #{user}" do
        block do
          api.setup_admin(user, password, setup_password)
          Chef::Log.info("Created #{new_resource}")
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
          api.create_admin(
            username: user, password: password, superadmin: superadmin,
            domain: [domains].flatten, active: active
          )
          Chef::Log.info("Created #{new_resource}")
        end
        action :create
      end
    end
  end
end

action :delete do
  self.class.send(:include, Chef::EncryptedAttributesHelpers)
  @encrypted_attributes_enabled = node['postfixadmin']['encrypt_attributes']
  api = PostfixadminCookbook::API.new(ssl, port, login_username, login_password)
  if login_username.nil? || login_password.nil?
    converge_by("Delete #{new_resource}") do
      raise 'You need to set `login_username` and `login_password` properties '\
            'to delete admins.'
    end
  else
    next unless api.admin_exist?(user)
    converge_by("Delete #{new_resource}") do
      ruby_block "delete admin #{user}" do
        block do
          api.delete_admin(user)
          Chef::Log.info("Deleted #{new_resource}")
        end
        action :create
      end
    end
  end
end
