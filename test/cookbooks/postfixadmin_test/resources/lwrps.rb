# encoding: UTF-8
#
# Cookbook Name:: postfixadmin_test
# Resource:: lwrps
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) Xabier de Zuazo
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
#

action :create do
  postfixadmin_admin 'admin@admin.org' do
    password 'p@ssw0rd1'
    action :create
  end

  postfixadmin_domain 'foobar.com' do
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
  end

  postfixadmin_admin 'admin2@foobar.com' do
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
  end

  postfixadmin_mailbox 'postmaster@foobar.com' do
    password 'p0stm@st3r1'
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
  end

  postfixadmin_alias 'admin@foobar.com' do
    goto 'postmaster@foobar.com'
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
  end

  postfixadmin_domain 'example.com' do
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
  end

  postfixadmin_alias_domain 'example.com' do
    target_domain 'foobar.com'
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
  end

  postfixadmin_domain 'todelete.com' do
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
    action :create
  end

  postfixadmin_admin 'todelete.admin@foobar.com' do
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
    action :create
  end

  postfixadmin_mailbox 'todelete.mailbox@foobar.com' do
    password 'p0stm@st3r1'
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
    action :create
  end

  postfixadmin_alias 'todelete.alias@foobar.com' do
    goto 'postmaster@foobar.com'
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
    action :create
  end

  postfixadmin_domain 'todelete.aliasdomain.com' do
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
    action :create
  end

  postfixadmin_alias_domain 'todelete.aliasdomain.com' do
    target_domain 'foobar.com'
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
    action :create
  end
end

action :delete do
  postfixadmin_domain 'nonexistingdomain.com' do
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
    action :delete
  end

  postfixadmin_domain 'todelete.com' do
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
    action :delete
  end

  postfixadmin_admin 'todelete.admin@foobar.com' do
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
    action :delete
  end

  postfixadmin_mailbox 'todelete.mailbox@foobar.com' do
    password 'p0stm@st3r1'
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
    action :delete
  end

  postfixadmin_alias 'todelete.alias@foobar.com' do
    goto 'postmaster@foobar.com'
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
    action :delete
  end

  postfixadmin_domain 'todelete.aliasdomain.com' do
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
    action :delete
  end

  postfixadmin_alias_domain 'todelete.aliasdomain.com' do
    target_domain 'foobar.com'
    login_username 'admin@admin.org'
    login_password 'p@ssw0rd1'
    action :delete
  end
end
