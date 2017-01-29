# encoding: UTF-8
#
# Cookbook Name:: postfixadmin
# Library:: api_http
# Author:: Xabier de Zuazo (<xabier@zuazo.org>)
# Copyright:: Copyright (c) 2014-2015 Onddo Labs, SL.
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

module PostfixAdmin
  class API
    # Internal wrapper to send PostfixAdmin HTTP calls
    class HTTP
      # Internal wrapper to ruby HTTP requests
      class Request
        # rubocop:disable Style/ClassVars

        @@cookie = nil

        def self.cookie
          @@cookie
        end

        def self.cookie=(arg)
          @@cookie = arg
        end

        # rubocop:enable Style/ClassVars

        def self.default_proto(ssl)
          ssl ? 'https' : 'http'
        end

        def self.default_port(ssl)
          ssl ? 443 : 80
        end

        def self.create_uri(path, ssl, port)
          proto = default_proto(ssl)
          port = default_port(ssl) if port.nil?
          URI.parse("#{proto}://127.0.0.1:#{port}#{path}")
        end

        def self.user_agent
          if defined?(Chef::HTTP::HTTPRequest)
            Chef::HTTP::HTTPRequest.user_agent
          else
            Chef::REST::RESTRequest.user_agent
          end
        end

        def self.create_http(uri, ssl)
          http = Net::HTTP.new(uri.host, uri.port)
          if ssl
            require 'net/https'
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end
          http.set_debug_output $stderr if Chef::Config[:log_level] == :debug
          http
        end

        def self.create_request(method, uri)
          case method.downcase
          when 'post'
            request = Net::HTTP::Post.new(uri.request_uri)
            request['Content-Type'] = 'application/x-www-form-urlencoded'
          else
            request = Net::HTTP::Get.new(uri.request_uri)
          end
          request['User-Agent'] = user_agent
          request['Cookie'] = cookie unless cookie.nil?
          request
        end

        def self.parse_cookie(response)
          if response['Set-Cookie'].is_a?(String)
            self.cookie = response['set-cookie'].split(';')[0]
            Chef::Log.debug("#{name}##{__method__} cookie: #{cookie}")
          end
        end

        def self.parse_response(response)
          parse_cookie(response)
          response
        end

        def initialize(method, path, body, ssl, port)
          uri = self.class.create_uri(path, ssl, port)
          Chef::Log.debug("#{self.class}: #{method} #{uri}")
          @http = self.class.create_http(uri, ssl)
          @request = self.class.create_request(method, uri)
          @request.set_form_data(body) unless body.nil?
        end

        def response
          response = @http.request(@request)
          self.class.parse_response(response)
        end
      end # Request

      unless defined?(::PostfixAdmin::API::HTTP::STDOUT_REGEXP)
        STDOUT_REGEXP = /^.*class=['"]standout['"][^>]*>([^\n]*?)\n.*$/m
      end
      unless defined?(::PostfixAdmin::API::HTTP::ERROR_REGEXP)
        ERROR_REGEXP = /^.*class=['"]error_msg['"][^>]*>([^<]*)<.*$/m
      end
      unless defined?(::PostfixAdmin::API::HTTP::SETUP_ERROR_REGEXP)
        SETUP_ERROR_REGEXP = /Setup +password +not +specified +correctly/
      end

      # rubocop:disable Style/ClassVars

      @@authenticated = false

      def self.authenticated=(arg)
        @@authenticated = arg
      end

      def self.authenticated?
        @@authenticated == true
      end

      # rubocop:enable Style/ClassVars

      def self.strip_html(html)
        html.gsub(%r{</?[^>]+?>}, ' ')
      end

      def self.parse_response_error(body)
        if body.match(ERROR_REGEXP)
          error_msg = "#{name}##{__method__}: #{body.gsub(ERROR_REGEXP, '\1')}"
          Chef::Log.fatal(error_msg)
          raise error_msg
        elsif body.match(SETUP_ERROR_REGEXP)
          raise strip_html(body.gsub(STDOUT_REGEXP, '\1'))
        end
      end

      def self.parse_response_body(body)
        parse_response_error(body)
        strip_html(body.gsub(STDOUT_REGEXP, '\1')) if body.match(STDOUT_REGEXP)
      end

      def self.request(method, path, body, ssl, port)
        response =
          API::HTTP::Request.new(method, path, body, ssl, port).response
        if response.code.to_i >= 400
          error_msg =
            "#{name}##{__method__}: #{response.code} #{response.message}"
          Chef::Log.fatal(error_msg)
          raise error_msg
        else
          parse_response_body(response.body)
        end
      end

      def self.get(path, ssl = false, port = nil)
        request('get', path, nil, ssl, port)
      end

      def self.post(path, body, ssl = false, port = nil)
        request('post', path, body, ssl, port)
      end

      def self.index(ssl = false, port = nil)
        get('/login.php', ssl, port)
      end

      def self.setup(body, ssl = false, port = nil)
        post('/setup.php', body, ssl, port)
      end

      attr_writer :username, :password, :ssl

      def initialize(username = nil, password = nil, ssl = false, port = nil)
        @username = username
        @password = password
        @ssl = ssl
        @port = port
      end

      def setup(username, password, setup_password)
        body = {
          form: 'createadmin',
          setup_password: setup_password,
          fUsername: username,
          fPassword: password, fPassword2: password,
          submit: 'Add+Admin'
        }
        self.class.setup(body, @ssl, @port)
      end

      def login
        return if self.class.authenticated?
        self.class.index(@ssl, @port)
        body = {
          fUsername: @username,
          fPassword: @password,
          lang: 'en',
          submit: 'Login'
        }
        self.class.post('/login.php', body, @ssl, @port)
        self.class.authenticated = true
      end

      def get(path)
        login
        self.class.get(path, @ssl, @port)
      end

      def post(path, body)
        login
        self.class.post(path, body, @ssl, @port)
      end
    end
  end
end
