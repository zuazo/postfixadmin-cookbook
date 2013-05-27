
require 'uri'
require 'net/http'

module PostfixAdmin
  module API

    def self.setup(body, ssl=false)

      proto = ssl ? 'https' : 'http'
      port = ssl ? 443 : 80
      uri = URI.parse("#{proto}://localhost:#{port}/setup.php")
      http = Net::HTTP.new(uri.host, uri.port)
      if ssl
        require 'net/https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      # http.set_debug_output $stderr # DEBUG

      request = Net::HTTP::Post.new(uri.request_uri)
      request['User-Agent'] = "Chef/#{Chef::VERSION}"
      request['Content-Type'] = 'application/x-www-form-urlencoded'
      request.set_form_data(body)

      response = http.request(request)
      if (response.code.to_i >= 400)
        error_msg = "#{self.name}##{__method__.to_s}: #{response.code} #{response.message}"
        Chef::Log.fatal(error_msg)
        raise error_msg
      elsif response.body.match(/^.*class=['"]error_msg['"][^>]*>([^<]*)<.*$/)
        error_msg = response.body.gsub(/^.*class=['"]error_msg['"][^>]*>([^<]*)<.*$/m, '\1')
        Chef::Log.fatal("#{self.name}##{__method__.to_s}: #{error_msg}")
        raise "#{self.name}##{__method__.to_s}"
      elsif response.body.match(/^.*class=['"]standout['"][^>]*>([^<]*)<.*$/)
        return response.body.gsub(/^.*class=['"]standout['"][^>]*>([^<]*)<.*$/m, '\1')
      end
      return nil
    end

    def self.createAdmin(username, password, setup_password, ssl=false)
      body = {
        'form' => 'createadmin',
        'setup_password' => setup_password,
        'fUsername' => username,
        'fPassword' => password,
        'fPassword2' => password,
        'submit' => 'Add+Admin',
      }
      setup(body, ssl)
    end

  end

end
