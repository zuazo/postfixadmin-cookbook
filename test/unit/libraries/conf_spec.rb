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
require 'conf'

describe PostfixAdmin::Conf, order: :random do
  describe '.value' do
    it "returns 'YES' for true" do
      expect(described_class.value(true)).to eq("'YES'")
    end

    it "returns 'NO' for false" do
      expect(described_class.value(false)).to eq("'NO'")
    end

    it 'converts to PHP for other values' do
      value = 'MyValue'
      expect(PostfixAdmin::PHP).to receive(:ruby_value_to_php).with(value).once
      described_class.value(value)
    end
  end
end
