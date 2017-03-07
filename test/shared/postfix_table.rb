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

class PostfixTable
  PATH = '/etc/postfix/tables'.freeze

  def initialize(file)
    @file = "#{PATH}/#{file}"
  end

  def parse_line(line, result, prevkey)
    return [prevkey, "#{result[prevkey]}\n#{line}"] if line[0] == ' '
    line = line.split('#', 2)[0] || ''
    line.split(/\s*=\s*/, 2)
  end

  def parse
    prevkey = nil
    @table = File.readlines(@file).each_with_object({}) do |line, result|
      key, value = parse_line(line.chomp, result, prevkey)
      result[key] = value unless value.nil?
    end
    self
  end

  def mysql
    {
      user: @table['user'], password: @table['password'],
      database: @table['dbname']
    }
  end

  def query
    @table['query'].gsub(/%./, '%s')
  end

  def [](key)
    @table[key]
  end
end
