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
  api = PostfixadminCookbook::API.new(ssl, port, login_username, login_password)
  next if api.mailbox_exist?(mailbox)
  converge_by("Create #{new_resource}") do
    ruby_block "create mailbox #{mailbox}" do
      block do
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
