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

require 'infrataster-plugin-mysql'

module Infrataster
  module Resources
    class MysqlQueryResource < BaseResource
      attr_reader :options
    end
  end
end

module Infrataster
  module Contexts
    class MysqlQueryContext < BaseContext
      # rubocop:disable Metrics/AbcSize
      # rubocop:disable Metrics/MethodLength
      def results
        options = { port: 3306, user: 'root', password: '' }
        if server.options[:mysql]
          options = options.merge(server.options[:mysql])
        end
        options = options.merge(resource.options)

        server.forward_port(options[:port]) do |address, new_port|
          mysql2_options = {
            host: address,
            port: new_port,
            username: options[:user],
            password: options[:password]
          }
          if options.key?(:database)
            mysql2_options[:database] = options[:database]
          end
          client = Mysql2::Client.new(mysql2_options)
          client.xquery(resource.query, *resource.params)
        end
      end
      # rubocop:enable Metrics/MethodLength
      # rubocop:enable Metrics/AbcSize
    end
  end
end
