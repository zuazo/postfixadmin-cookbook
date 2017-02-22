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

def sample_file(file)
  File.join(::File.dirname(__FILE__), '..', 'samples', file)
end

def sample(file)
  File.read(sample_file(file))
end

describe PostfixAdmin::API::HTTP, order: :random do
  let(:path) { '/' }
  let(:url) { "127.0.0.1:80#{path}" }

  describe '.get_token' do
    let(:path) { '/edit.php?table=domain' }
    let(:token) { '6c2ef0d4187972393f047120f3fbc5f1' }
    before do
      stub_request(:get, url).to_return(body: sample('edit_domain.html'))
    end

    it 'returns the token' do
      expect(described_class.get_token(path)).to eq(token)
    end
  end
end
