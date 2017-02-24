# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Library:: matchers
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2014 Onddo Labs, SL.
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

if defined?(ChefSpec)
  %i(
    postfixadmin_admin
    postfixadmin_alias
    postfixadmin_alias_domain
    postfixadmin_domain
    postfixadmin_mailbox
  ).each do |matcher|
    ChefSpec.define_matcher matcher
  end

  def create_postfixadmin_admin(user)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postfixadmin_admin, :create, user
    )
  end

  def delete_postfixadmin_admin(user)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postfixadmin_admin, :delete, user
    )
  end

  def create_postfixadmin_alias(address)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postfixadmin_alias, :create, address
    )
  end

  def delete_postfixadmin_alias(address)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postfixadmin_alias, :delete, address
    )
  end

  def create_postfixadmin_alias_domain(alias_domain)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postfixadmin_alias_domain, :create, alias_domain
    )
  end

  def delete_postfixadmin_alias_domain(alias_domain)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postfixadmin_alias_domain, :delete, alias_domain
    )
  end

  def create_postfixadmin_domain(domain)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postfixadmin_domain, :create, domain
    )
  end

  def delete_postfixadmin_domain(domain)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postfixadmin_domain, :delete, domain
    )
  end

  def delete_postfixadmin_mailbox(mailbox)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postfixadmin_mailbox, :delete, mailbox
    )
  end

  def create_postfixadmin_mailbox(mailbox)
    ChefSpec::Matchers::ResourceMatcher.new(
      :postfixadmin_mailbox, :create, mailbox
    )
  end
end
