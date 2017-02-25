# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Resource:: mailbox
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

property :mailbox, String, name_property: true
property :password, String, sensitive: true
property :name, String, default: ''
property :active, [TrueClass, FalseClass], default: true
property :mail, [TrueClass, FalseClass], default: false
property :login_username, String, required: true
property :login_password, String, required: true, sensitive: true
property :ssl, [TrueClass, FalseClass], default: lazy { default_ssl }
property :port, [Integer, String, NilClass], default: lazy { default_port }

include PostfixadminCookbook::ResourceHelpers

action :create do
  self.class.send(:include, Chef::EncryptedAttributesHelpers)
  @encrypted_attributes_enabled = node['postfixadmin']['encrypt_attributes']
  username, domain = mailbox.split('@', 2)
  if domain.nil?
    raise Chef::Exceptions::ArgumentError,
          'Could not get the domain name from the mailbox argument, it should '\
          'have the following format: user@domain.tld'
  end
  api = PostfixadminCookbook::API.new(ssl, port, login_username, login_password)
  next if api.mailbox_exist?(mailbox)
  converge_by("Create #{new_resource}") do
    ruby_block "create mailbox #{mailbox}" do
      block do
        api.create_mailbox(
          local_part: username, domain: domain, password: password,
          name: mailbox, active: active, welcome_mail: mail
        )
        Chef::Log.info("Created #{new_resource}")
      end
      action :create
    end
  end
end

action :delete do
  self.class.send(:include, Chef::EncryptedAttributesHelpers)
  @encrypted_attributes_enabled = node['postfixadmin']['encrypt_attributes']
  api = PostfixadminCookbook::API.new(ssl, port, login_username, login_password)
  next unless api.mailbox_exist?(mailbox)
  converge_by("Delete #{new_resource}") do
    ruby_block "delete mailbox #{mailbox}" do
      block do
        api.delete_mailbox(mailbox)
        Chef::Log.info("Deleted #{new_resource}")
      end
      action :create
    end
  end
end
