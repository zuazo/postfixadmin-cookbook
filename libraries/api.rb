# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Library:: api
# Author:: Xabier de Zuazo (<xabier@onddo.com>)
# Copyright:: Copyright (c) 2013 Onddo Labs, SL. (www.onddo.com)
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

    def create_domain(domain, description, aliases, mailboxes)
      body = {
        fDomain: domain,
        fDescription: description,
        fAliases: aliases,
        fMailboxes: mailboxes,
        submit: 'Add+Domain'
      }
      @http.post('/create-domain.php', body)
    end

    # rubocop:disable Metrics/ParameterLists
    def create_mailbox(username, domain, password, name, active, mail)
      # rubocop:enable Metrics/ParameterLists
      body = {
        fUsername: username,
        fDomain: domain,
        fPassword: password, fPassword2: password,
        fName: name,
        submit: 'Add+Mailbox'
      }
      body['fActive'] = 'on' if active
      body['fMail'] = 'on' if mail
      @http.post('/create-mailbox.php', body)
    end

    def create_alias(address, domain, goto, active)
      body = {
        fAddress: address,
        fDomain: domain,
        fGoto: goto,
        submit: 'Add+Alias'
      }
      body['fActive'] = 'on' if active
      @http.post('/create-alias.php', body)
    end

    def create_alias_domain(alias_domain, target_domain, active)
      body = {
        alias_domain: alias_domain,
        target_domain: target_domain,
        submit: 'Add+Alias+Domain'
      }
      body['active'] = '1' if active
      @http.post('/create-alias-domain.php', body)
    end
  end
end
