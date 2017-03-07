# encoding: UTF-8
#
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2017 Xabier de Zuazo
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
require_relative '../../../kitchen/data/infrataster_mysql_hack'
require_relative '../../../kitchen/data/postfix_table'

describe 'map files' do
  describe server(:db) do
    describe 'db_virtual_domains_maps.cf' do
      table = PostfixTable.new(description).parse

      describe mysql_query(table.query % 'foobar.com', table.mysql) do
        it 'includes "foobar.com" domain' do
          expect(results.first['domain']).to eq('foobar.com')
        end
      end
    end

    describe 'db_virtual_alias_maps.cf' do
      table = PostfixTable.new(description).parse

      describe mysql_query(table.query % 'admin@foobar.com', table.mysql) do
        it 'includes "admin@foobar.com" alias' do
          expect(results.first['goto']).to eq('postmaster@foobar.com')
        end
      end
    end

    describe 'db_virtual_alias_domain_maps.cf' do
      table = PostfixTable.new(description).parse

      describe mysql_query(
        format(table.query, 'example.com', 'admin'), table.mysql
      ) do
        it 'includes "admin@example.com" alias domain' do
          expect(results.first['goto']).to eq('postmaster@foobar.com')
        end
      end
    end

    describe 'db_virtual_alias_domain_catchall_maps.cf' do
      table = PostfixTable.new(description).parse

      describe mysql_query(format(table.query, 'example.com'), table.mysql) do
        it 'is empty' do
          expect(results.to_a).to be_empty
        end
      end
    end

    describe 'db_virtual_mailbox_maps.cf' do
      table = PostfixTable.new(description).parse

      describe mysql_query(
        format(table.query, 'postmaster@foobar.com'), table.mysql
      ) do
        it 'includes "foobar.com/postmaster/" maildir' do
          expect(results.first['maildir']).to eq('foobar.com/postmaster/')
        end
      end
    end

    describe 'db_virtual_alias_domain_mailbox_maps.cf' do
      table = PostfixTable.new(description).parse

      describe mysql_query(
        format(table.query, 'example.com', 'postmaster'), table.mysql
      ) do
        it 'includes "foobar.com/postmaster/" maildir' do
          expect(results.first['maildir']).to eq('foobar.com/postmaster/')
        end
      end
    end
  end # server db
end # mysql
