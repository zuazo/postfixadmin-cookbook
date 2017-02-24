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
require 'matchers'

describe 'ChefSpec matchers', order: :random do
  matchers = {
    postfixadmin_admin: %i(create delete),
    postfixadmin_alias: %i(create delete),
    postfixadmin_alias_domain: %i(create delete),
    postfixadmin_domain: %i(create delete),
    postfixadmin_mailbox: %i(create delete),

    # support/matchers
    ark: %i(
      install dump cherry_pick put install_with_make configure setup_py_build
      setup_py_install setup_py unzip
    )
  }

  matchers.each do |resource, actions|
    actions.each do |action|
      name = 'myname'
      meth = "#{action}_#{resource}"
      it meth do
        expect(ChefSpec::Matchers::ResourceMatcher).to receive(:new)
          .with(resource, action, name).once
        send(meth, name)
      end
    end
  end
end
