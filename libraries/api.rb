
require 'uri'
require 'net/http'

module PostfixAdmin
  module API
    @@cookie = nil
    @@authenticated = false

    def self.request(method, path, body, ssl=false)
      proto = ssl ? 'https' : 'http'
      port = ssl ? 443 : 80
      uri = URI.parse("#{proto}://localhost:#{port}#{path}")
      http = Net::HTTP.new(uri.host, uri.port)
      if ssl
        require 'net/https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      # http.set_debug_output $stderr # DEBUG

      case method.downcase
      when 'post'
        request = Net::HTTP::Post.new(uri.request_uri)
        request['Content-Type'] = 'application/x-www-form-urlencoded'
      else
        request = Net::HTTP::Get.new(uri.request_uri)
      end
      request['User-Agent'] = "Chef/#{Chef::VERSION}"
      unless @@cookie.nil?
        request['Cookie'] = @@cookie
      end
      request.set_form_data(body) unless body.nil?

      response = http.request(request)
      if response['Set-Cookie'].kind_of?(String)
        @@cookie = response['set-cookie'].split(';')[0]
        Chef::Log.debug("#{self.name}##{__method__.to_s} cookie: #{@@cookie}")
      end
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

    def self.get(path, ssl=false)
      request('get', path, nil, ssl)
    end

    def self.post(path, body, ssl=false)
      request('post', path, body, ssl)
    end

    def self.index(ssl=false)
      get('/login.php', ssl)
    end

    def self.setup(body, ssl=false)
      post('/setup.php', body, ssl)
    end

    def self.login(username, password, ssl=false)
      unless @@authenticated
        index
        body = {
          'fUsername' => username,
          'fPassword' => password,
          'lang' => 'en',
          'submit' => 'Login',
        }
        post('/login.php', body, ssl)
        @@authenticated = true
      end
    end

    def self.createDomain(domain, description, aliases, mailboxes, login_username, login_password, ssl=false)
      login(login_username, login_password, ssl)
      body = {
        'fDomain' => domain,
        'fDescription' => description,
        'fAliases' => aliases,
        'fMailboxes' => mailboxes,
        'submit' => 'Add+Domain',
      }
      post('/create-domain.php', body, ssl)
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

    def self.createMailbox(username, domain, password, name, active, mail, login_username, login_password, ssl=false)
      login(login_username, login_password, ssl)
      body = {
        'fUsername' => username,
        'fDomain' => domain,
        'fPassword' => password,
        'fPassword2' => password,
        'fName' => name,
        'submit' => 'Add+Mailbox',
      }
      body['fActive'] = 'on' if (active)
      body['fMail'] = 'on' if (mail)
      post('/create-mailbox.php', body, ssl)
    end

    def self.createAlias(address, domain, goto, active, login_username, login_password, ssl=false)
      login(login_username, login_password, ssl)
      body = {
        'fAddress' => address,
        'fDomain' => domain,
        'fGoto' => goto,
        'submit' => 'Add+Alias',
      }
      body['fActive'] = 'on' if (active)
      post('/create-alias.php', body, ssl)
    end

  end
end

