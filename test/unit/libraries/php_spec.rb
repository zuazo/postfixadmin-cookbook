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
require 'php'

class FakeRecipe
  include PostfixadminCookbook::PHP

  def node
    Chef::Node.new.tap do |n|
      n.name('node1')
      n.automatic['fqdn'] = 'myhostname'
    end
  end
end

describe PostfixadminCookbook::PHP, order: :random do
  subject { FakeRecipe.new }
  let(:node) do
  end

  describe '#generate_setup_password_salt' do
    it 'returns a valid salt' do
      expect(subject.generate_setup_password_salt)
        .to match(/^[0-9a-f]{32}$/)
    end
  end

  describe '#encrypt_setup_password' do
    let(:salt) { subject.generate_setup_password_salt }
    let(:password) { 'SuperSecret' }

    it 'returns a valid password' do
      expect(subject.encrypt_setup_password(password, salt))
        .to match(/^[0-9a-f]{32}:[0-9a-f]{40}$/)
    end
  end

  describe '.ruby_value_to_php' do
    it 'converts nil to NULL' do
      expect(described_class.ruby_value_to_php(nil)).to eq('NULL')
    end

    it 'returns integers' do
      num = 5
      expect(described_class.ruby_value_to_php(num)).to eq(num)
    end

    it 'returns floats' do
      num = 5.2
      expect(described_class.ruby_value_to_php(num)).to eq(num)
    end

    it 'converts arrays' do
      input = [1, 2.2, 'String', [1]]
      output = "array(1, 2.2, 'String', array(1))"
      expect(described_class.ruby_value_to_php(input)).to eq(output)
    end

    it 'converts nested arrays' do
      input = [1, 2.2, 'String', [1], { a: 2 }]
      output = "array(1, 2.2, 'String', array(1), array('a' => 2))"
      expect(described_class.ruby_value_to_php(input)).to eq(output)
    end

    it 'converts hashes' do
      input = { a: 1, b: 'c' }
      output = "array('a' => 1, 'b' => 'c')"
      expect(described_class.ruby_value_to_php(input)).to eq(output)
    end

    it 'converts nested hashes' do
      input = { a: 1, b: 'c', d: [1, 2, 6], e: { aa: 1 } }
      output =
        "array('a' => 1, 'b' => 'c', 'd' => array(1, 2, 6), "\
        "'e' => array('aa' => 1))"
      expect(described_class.ruby_value_to_php(input)).to eq(output)
    end
  end
end
