# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Library:: api
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
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

module PostfixAdmin
  # Static class to make PostfixAdmin API calls
  class API
    def initialize(ssl = false, port = nil, username = nil, password = nil)
      @http = API::HTTP.new(username, password, ssl, port)
    end

    def create_admin(username, password, setup_password)
      @http.setup(username, password, setup_password)
    end

    def create_to_table(table, value)
      url = "/edit.php?table=#{table}"
      body = {
        submit: "Add+#{table.capitalize}",
        table: table,
        value: value
      }
      @http.post(url, body)
    end

    def create_domain(value)
      create_to_table('domain', value)
    end

    def create_mailbox(value)
      value[:active] = value[:active] ? 1 : 0
      value[:welcome_mail] = value[:welcome_mail] ? 1 : 0
      value[:password2] = value[:password]
      create_to_table('mailbox', value)
    end

    def create_alias(value)
      value[:active] = value[:active] ? 1 : 0
      create_to_table('alias', value)
    end

    def create_alias_domain(value)
      value[:active] = value[:active] ? 1 : 0
      create_to_table('aliasdomain', value)
    end
  end
end
