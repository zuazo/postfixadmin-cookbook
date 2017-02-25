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

require_relative '../spec_helper'
require 'resource_helpers'

class FakeRecipe
  include PostfixadminCookbook::ResourceHelpers
end

describe PostfixadminCookbook::ResourceHelpers, order: :random do
  let(:subject) { FakeRecipe.new }
  let(:node) do
    Chef::Node.new.tap do |n|
      n.name('node1')
      n.automatic['fqdn'] = 'myhostname'
    end
  end
  before do
    allow(subject).to receive(:node).and_return(node)
    node.default['postfixadmin']['ssl'] = 'SSL_VALUE'
    node.default['postfixadmin']['port'] = 12_345
  end

  describe '#default_ssl' do
    context "when `node['postfixadmin']['ssl']` is true" do
      before { node.default['postfixadmin']['ssl'] = true }

      it 'returns true' do
        expect(subject.default_ssl).to eq(true)
      end
    end

    context "when `node['postfixadmin']['ssl']` is false" do
      before { node.default['postfixadmin']['ssl'] = false }

      it 'returns false' do
        expect(subject.default_ssl).to eq(false)
      end
    end

    context "without `node['postfixadmin']['ssl']` set" do
      before { node.default['postfixadmin']['ssl'] = nil }

      it 'returns false' do
        expect(subject.default_ssl).to eq(false)
      end
    end
  end

  describe '#default_port' do
    it "returns `node['postfixadmin']['port']` attribute value" do
      expect(subject.default_port).to eq(node['postfixadmin']['port'])
    end

    context "without `node['postfixadmin']['port']` set" do
      before { node.default['postfixadmin']['port'] = nil }

      it 'returns 80 without ssl' do
        node.default['postfixadmin']['ssl'] = false
        expect(subject.default_port).to eq(80)
      end

      it 'returns 443 without ssl' do
        node.default['postfixadmin']['ssl'] = true
        expect(subject.default_port).to eq(443)
      end
    end
  end
end
