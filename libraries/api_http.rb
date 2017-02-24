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

module PostfixadminCookbook
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

        def default_proto(ssl)
          ssl ? 'https' : 'http'
        end

        def default_port(ssl)
          ssl ? 443 : 80
        end

        def create_uri(path, ssl, port)
          proto = default_proto(ssl)
          port = default_port(ssl) if port.nil?
          URI.parse("#{proto}://127.0.0.1:#{port}#{path}")
        end

        def user_agent
          Chef::HTTP::HTTPRequest.user_agent
        end

        def create_http(uri, ssl)
          http = Net::HTTP.new(uri.host, uri.port)
          if ssl
            require 'net/https'
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end
          http.set_debug_output $stderr if Chef::Config[:log_level] == :debug
          http
        end

        def create_request(method, uri)
          case method.downcase
          when 'post'
            request = Net::HTTP::Post.new(uri.request_uri)
            request['Content-Type'] = 'application/x-www-form-urlencoded'
          else
            request = Net::HTTP::Get.new(uri.request_uri)
          end
          request['User-Agent'] = user_agent
          request['Cookie'] = self.class.cookie unless self.class.cookie.nil?
          request
        end

        def parse_cookie(response)
          return unless response['Set-Cookie'].is_a?(String)
          self.class.cookie = response['Set-Cookie'].split(';')[0]
          Chef::Log.debug(
            "#{self.class.name}##{__method__} cookie: #{self.class.cookie}"
          )
        end

        def parse_response(response)
          parse_cookie(response)
          response
        end

        def initialize(method, path, body, ssl, port)
          uri = create_uri(path, ssl, port)
          Chef::Log.debug("#{self.class}: #{method} #{uri}")
          @http = create_http(uri, ssl)
          @request = create_request(method, uri)
          @request.set_form_data(serialize_body(body)) unless body.nil?
        end

        #
        # Returns a key, value pair for processing it with PHP web application.
        #
        # @param key [String, Symbol] Name of the hash key.
        # @param value [Mixed] value of the key.
        # @return [Array<Array>] an array of arrays with the key, value pairs.
        # @example
        #   serialize_php_body('key1', sub1: 'a', sub2: 'b')
        #     #=> [["key1[sub1]", "a"], ["key1[sub2]", "b"]]
        #   serialize_php_body('key1', sub1: 'a', sub2: { subsub3: 'b' })
        #     #=> [["key1[sub1]", "a"], ["key1[sub2][subsub3]", "b"]]
        def serialize_php_body(key, value)
          case value
          when Hash then value.reduce([]) do |m, (k2, v2)|
                           m + serialize_php_body("#{key}[#{k2}]", v2)
                         end
          when Array then value.reduce([]) do |m, v2|
                            # TODO: only one value is accepted for arrays
                            m + serialize_php_body("#{key}[]", v2)
                          end
          else [[key, value]]
          end
        end

        def serialize_body(body)
          return body unless body.is_a?(Hash)
          body.reduce({}) do |hs, (key, value)|
            hs.merge(serialize_php_body(key, value).to_h)
          end
        end

        def response
          response = @http.request(@request)
          parse_response(response)
        end
      end # Request

      unless defined?(::PostfixadminCookbook::API::HTTP::ERROR_REGEXS)
        ERROR_REGEXS = [
          /^.*class=['"]error_msg['"][^>]*>([^<]+)<.*$/m,
          /^.*(Invalid\s+token!).*$/m
        ].freeze
      end
      unless defined?(::PostfixadminCookbook::API::HTTP::SETUP_OK_REGEX)
        SETUP_OK_REGEX = /You +are +done +with +your +basic +setup/
      end
      unless defined?(::PostfixadminCookbook::API::HTTP::SETUP_ERROR_REGEXS)
        SETUP_ERROR_REGEXS = [
          %r{^.*<b>(Error: .+)</b>.*Please fix the errors listed above.*$}m,
          /^.*class=['"]standout['"][^>]*>([^<]+?)<.*$/m,
          %r{^.*<tr>\s*(?:<td>.+?</td>\s*){2}<td>([^<]+?)</td>\s*</tr>.*$}m
        ].freeze
      end
      unless defined?(::PostfixadminCookbook::API::HTTP::DELETE_ERROR_REGEX)
        DELETE_ERROR_REGEX =
          %r{^.*class=['"]flash-error['"][^>]*>(?:<li>)?([^<]+?)(?:</li>)?<.*$}m
      end
      unless defined?(::PostfixadminCookbook::API::HTTP::TOKEN_REGEX)
        TOKEN_REGEX = /^.*<input\s+[^>]*name="token"\s+value="([^"]+)".*$/m
      end

      class TokenError < StandardError; end

      # rubocop:disable Style/ClassVars

      @@token = nil

      def self.token
        @@token
      end

      def self.token=(arg)
        @@token = arg
      end

      # rubocop:enable Style/ClassVars

      def strip_html(html)
        html.gsub(%r{</?[^>]+?>}, ' ')
      end

      def error(error_msg, e_class = RuntimeError)
        Chef::Log.fatal(error_msg) if e_class == RuntimeError
        raise e_class, error_msg
      end

      def parse_setup(body)
        return if body.match(SETUP_OK_REGEX)
        SETUP_ERROR_REGEXS.each do |regexp|
          next unless body.match(regexp)
          error(strip_html(body.gsub(regexp, '\1')))
        end
        error("Unknown error during the setup of Postfix Admin:\n\n#{body}")
      end

      def parse_response(body, regexps = nil)
        (regexps ? [regexps].flatten : ERROR_REGEXS).each do |regexp|
          next unless body.match(regexp)
          error(strip_html(body.gsub(regexp, '\1')))
        end
      end

      def request(method, path, body, ssl, port)
        resp = API::HTTP::Request.new(method, path, body, ssl, port).response
        error("#{resp.code} #{resp.message}") if resp.code.to_i >= 400
        block_given? ? yield(resp.body) : parse_response(resp.body)
      end

      attr_writer :username, :password, :ssl

      def initialize(username = nil, password = nil, ssl = false, port = nil)
        @username = username
        @password = password
        @ssl = ssl
        @port = port
      end

      def setup(username, password, setup_password)
        body = { form: 'createadmin', setup_password: setup_password,
                 username: username, password: password, password2: password,
                 submit: 'Add+Admin' }
        request('post', '/setup.php', body, @ssl, @port) { |x| parse_setup(x) }
      end

      def get_token(url, ssl = false, port = nil)
        request('get', url, nil, ssl, port) do |x|
          error('Token not found.', TokenError) unless x.match(TOKEN_REGEX)
          self.class.token = x.gsub(TOKEN_REGEX, '\1')
        end
      end

      def login
        return unless self.class.token.nil?
        request('get', '/login.php', nil, @ssl, @port) # get cookie
        body = { fUsername: @username, fPassword: @password, lang: 'en',
                 submit: 'Login' }
        request('post', '/login.php', body, @ssl, @port)
        get_token('/edit.php?table=domain', @ssl, @port)
      end

      def get(path, &block)
        login
        request('get', path, nil, @ssl, @port, &block)
      end

      def post(path, body, &block)
        login
        body[:token] = self.class.token unless self.class.token.nil?
        request('post', path, body, @ssl, @port, &block)
      end

      def delete(path)
        get("#{path}&token=#{self.class.token}") do |x|
          parse_response(x, DELETE_ERROR_REGEX)
        end
      end
    end
  end
end
