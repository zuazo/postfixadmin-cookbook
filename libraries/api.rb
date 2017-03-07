# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Library:: api
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2013 Onddo Labs, SL.
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

require 'csv'
require_relative 'api_http'

module PostfixadminCookbook
  # Static class to make PostfixAdmin API calls
  class API
    unless defined?(::PostfixadminCookbook::API::IGNORE_CSV_FIELD_REGEXP)
      IGNORE_CSV_FIELD_REGEXP = /^(&nbsp;|\s)*$/
    end

    def load_depends
      return if defined?(Addressable)
      Chef::Log.info("Trying to load 'addressable' at runtime.")
      Gem.clear_paths
      require 'addressable'
    end

    def initialize(ssl = false, port = nil, username = nil, password = nil)
      @ssl = ssl
      @port = port
      @http = API::HTTP.new(username, password, @ssl, @port)
      load_depends
    end

    def setup?(username, password)
      http = API::HTTP.new(username, password, @ssl, @port)
      http.login.is_a?(String)
    rescue API::HTTP::TokenError
      false
    end

    def setup_admin(username, password, setup_password)
      @http.setup(username, password, setup_password)
    end

    def parse_csv_line(line)
      first = line.shift
      # HACK: Avoid "&snbp;" values in the first column:
      first = line.shift if first.match(IGNORE_CSV_FIELD_REGEXP)
      [first, line]
    end

    def parse_csv(csv)
      csv.shift if [["\xEF\xBB\xBF"], ['']].include?(csv.first)
      csv.shift # CSV header
      csv.each_with_object({}) do |line, memo|
        k, v = parse_csv_line(line)
        memo[k] = v
      end
    end

    def list_table(table)
      @http.get("/list.php?table=#{table}&output=csv") do |body|
        csv = CSV.parse(body, col_sep: ';')
        parse_csv(csv)
      end
    end

    def create_to_table(table, value)
      %i(active superadmin welcome_mail default_aliases).each do |key|
        value[key] = value[key] ? 1 : 0 if value.key?(key)
      end
      value[:password2] = value[:password] if value.key?(:password)
      uri = Addressable::URI.parse('/edit.php')
      uri.query_values = { table: table }
      body = { submit: "Add+#{table.capitalize}", table: table, value: value }
      @http.post(uri.normalize.to_s, body)
    end

    def delete_from_table(table, value)
      uri = Addressable::URI.parse('/delete.php')
      uri.query_values = { table: table, delete: value }
      @http.delete(uri.normalize.to_s)
    end

    %w(admin domain mailbox alias alias_domain).each do |resource|
      table = resource.delete('_')

      define_method("#{resource}_exist?") do |value|
        list_table(table).key?(value.to_s)
      end

      define_method("create_#{resource}") do |value|
        create_to_table(table, value)
      end

      define_method("delete_#{resource}") do |value|
        delete_from_table(table, value)
      end
    end
  end
end
