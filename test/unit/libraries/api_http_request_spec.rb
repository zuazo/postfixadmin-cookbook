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
require 'api_http'

describe PostfixadminCookbook::API::HTTP::Request, order: :random do
  subject { described_class.new(:get, '/', nil, false, 80) }

  describe '#serialize_body' do
    it 'does nothing for hash withtout sub-hashes' do
      input = { key1: 'val1', key2: 'val2' }
      output = input
      expect(subject.serialize_body(input)).to eq(output)
    end

    it 'serializes a sub-key' do
      input = { key1: 'val1', key2: { sub1: 'val3' } }
      output = { key1: 'val1', 'key2[sub1]' => 'val3' }
      expect(subject.serialize_body(input)).to eq(output)
    end

    it 'serializes a sub-sub-key' do
      input = { key1: 'val1', key2: { sub1: { subsub1: 'val3' } } }
      output = { key1: 'val1', 'key2[sub1][subsub1]' => 'val3' }
      expect(subject.serialize_body(input)).to eq(output)
    end

    it 'serializes a sub-array' do
      input = { key1: 'val1', key2: %w(val2 val3) }
      output = { key1: 'val1', 'key2[]' => 'val3' }
      expect(subject.serialize_body(input)).to eq(output)
    end

    it 'serializes a sub-hash-sub-array' do
      input = { key1: 'val1', key2: { sub1: %w(val2 val3) } }
      output = { key1: 'val1', 'key2[sub1][]' => 'val3' }
      expect(subject.serialize_body(input)).to eq(output)
    end

    it 'serializes a sub-sub-hash-sub-array' do
      input = { key1: 'val1', key2: { sub1: { subsub1: %w(val2 val3) } } }
      output = { key1: 'val1', 'key2[sub1][subsub1][]' => 'val3' }
      expect(subject.serialize_body(input)).to eq(output)
    end
  end
end
