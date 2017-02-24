# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Provider:: alias_domain
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
  next if api.alias_domain_exist?(alias_domain)
  converge_by("Create #{new_resource}") do
    ruby_block "create alias domain #{alias_domain}" do
      block do
        result = api.create_alias_domain(
          alias_domain: alias_domain, target_domain: target_domain,
          active: active
        )
        Chef::Log.info("Created #{new_resource}: #{result}")
      end
      action :create
    end
  end
end

action :delete do
  self.class.send(:include, Chef::EncryptedAttributesHelpers)
  @encrypted_attributes_enabled = node['postfixadmin']['encrypt_attributes']
  api = PostfixadminCookbook::API.new(ssl, port, login_username, login_password)
  next unless api.alias_domain_exist?(alias_domain)
  converge_by("Remove #{new_resource}") do
    ruby_block "delete alias domain #{alias_domain}" do
      block do
        result = api.delete_alias_domain(alias_domain)
        Chef::Log.info("Removed #{new_resource}: #{result}")
      end
      action :create
    end
  end
end
