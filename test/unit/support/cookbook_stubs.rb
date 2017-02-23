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

require 'api_http'

if defined?(ChefSpec)
  def stub_postfixadmin_setup
    stub_request(:post, 'http://127.0.0.1/setup.php')
      .to_return(body: sample('setup_ok.html'))
  end

  def stub_postfixadmin_login
    stub_request(:get, url('/login.php'))
      .to_return(body: sample('login.html'))
    stub_request(:post, url('/login.php'))
      .to_return(body: sample('login_ok.html'))
    stub_request(:get, url('/edit.php?table=domain')) # token
      .to_return(body: sample('edit_domain.html'))
  end

  def stub_postfixadmin_list(table)
    stub_request(:get, url("/list.php?table=#{table}&output=csv"))
      .to_return(body: sample('domain.csv'))
  end

  def stub_postfixadmin_http
    reset_cookies
    stub_postfixadmin_setup
    stub_postfixadmin_login
    stub_postfixadmin_list('domain')
    stub_postfixadmin_list('admin')
    stub_postfixadmin_list('mailbox')
    stub_postfixadmin_list('aliasdomain')
    stub_postfixadmin_list('alias')
  end
end
