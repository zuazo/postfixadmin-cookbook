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

module UnitTestHelpers
  def sample_file(file)
    File.join(::File.dirname(__FILE__), '..', 'samples', file)
  end

  def sample(file)
    File.read(sample_file(file))
  end

  def url(path)
    "127.0.0.1:80#{path}"
  end

  def force_cookie(cookie)
    ::PostfixadminCookbook::API::HTTP::Request.cookie = cookie
  end

  def force_token(token)
    ::PostfixadminCookbook::API::HTTP.token = token
  end

  def reset_cookies
    force_cookie(nil)
    force_token(nil)
  end
end
