# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2017 Xabier de Zuazo
# Copyright:: Copyright (c) 2015 Onddo Labs, SL.
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

require_relative '../../../kitchen/data/spec_helper'

describe server(:web) do
  describe http('/login.php') do
    it 'includes PHP cookie' do
      expect(response['Set-Cookie']).to include 'PHPSESSID'
    end

    it 'returns "Postfix Admin" string' do
      expect(response.body).to include('Postfix Admin')
    end
  end # http /login.php

  describe http('/setup.php') do
    it 'setup.php returns that everything is fine' do
      expect(response.body).to include('Everything seems fine')
    end

    it 'setup.php returns that database is up to date' do
      expect(response.body).to include('Database is up to date')
    end
  end # http /setup.php

  describe capybara('127.0.0.1'), if: phantomjs? do
    let(:user_email) { 'admin@admin.org' }
    let(:user_password) { 'p@ssw0rd1' }

    it 'signs in' do
      visit '/login.php'
      fill_in 'fUsername', with: user_email
      fill_in 'fPassword', with: user_password
      click_button 'Login'
      expect(page).to have_content 'Logged in as admin@admin.org'
    end

    it 'lists admins' do
      visit '/list-admin.php'
      expect(find('#admin_table')).to have_content 'admin@admin.org'
    end

    it 'lists domains' do
      visit '/list-domain.php'
      expect(find('#admin_table')).to have_content 'foobar.com'
    end

    context 'in virtual list' do
      before { visit '/list-virtual.php?domain=foobar.com' }

      it 'lists domain aliases' do
        expect(find('#alias_domain_table')).to have_content 'example.com'
      end

      it 'lists aliases' do
        expect(find('#alias_table tr:nth-child(3) > td:nth-child(1)'))
          .to have_content 'admin@foobar.com'
        expect(find('#alias_table tr:nth-child(3) > td:nth-child(2)'))
          .to have_content 'postmaster@foobar.com'
      end

      it 'lists mailboxes' do
        expect(find('#mailbox_table')).to have_content 'postmaster@foobar.com'
      end
    end # in virtual list
  end # capybara tests
end # server web
