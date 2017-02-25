# encoding: UTF-8
#
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
#

require_relative '../spec_helper'

describe 'postfixadmin::map_files', order: :random do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'creates tables directory' do
    allow(::File).to receive(:exist?).and_call_original
    allow(::File).to receive(:exist?).with('/etc/postfix/tables')
      .and_return(false)
    expect(chef_run).to create_directory('/etc/postfix/tables')
      .with_mode('00755')
      .with_owner('root')
      .with_group('postfix')
      .with_recursive(true)
  end

  %w(
    db_virtual_alias_maps.cf
    db_virtual_alias_domain_maps.cf
    db_virtual_alias_domain_catchall_maps.cf
    db_virtual_domains_maps.cf
    db_virtual_mailbox_maps.cf
    db_virtual_alias_domain_mailbox_maps.cf
    db_virtual_mailbox_limit_maps.cf
  ).each do |map_file|
    it "creates #{map_file} file" do
      file = "/etc/postfix/tables/#{map_file}"
      source = "sql/#{map_file}.erb"
      expect(chef_run).to create_template(file)
        .with_source(source)
        .with_mode('00640')
        .with_owner('root')
        .with_group('postfix')
        .with_sensitive(true)
    end
  end
end
