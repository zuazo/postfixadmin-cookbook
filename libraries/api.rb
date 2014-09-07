# encoding: UTF-8

module PostfixAdmin
  # Static class to make PostfixAdmin HTTP API requests
  module API
    # rubocop:disable Style/ClassVars
    @@cookie = nil
    @@authenticated = nil
    # rubocop:enable Style/ClassVars

    def self.request(method, path, body, ssl = false)
      proto = ssl ? 'https' : 'http'
      port = ssl ? 443 : 80
      uri = URI.parse("#{proto}://localhost:#{port}#{path}")
      http = Net::HTTP.new(uri.host, uri.port)
      if ssl
        require 'net/https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      http.set_debug_output $stderr if Chef::Config[:log_level] == :debug

      case method.downcase
      when 'post'
        request = Net::HTTP::Post.new(uri.request_uri)
        request['Content-Type'] = 'application/x-www-form-urlencoded'
      else
        request = Net::HTTP::Get.new(uri.request_uri)
      end
      request['User-Agent'] =
        if defined?(Chef::HTTP::HTTPRequest)
          Chef::HTTP::HTTPRequest.user_agent
        else
          Chef::REST::RESTRequest.user_agent
        end
      request['Cookie'] = @@cookie unless @@cookie.nil? # rubocop:disable Style/ClassVars
      request.set_form_data(body) unless body.nil?

      response = http.request(request)
      if response['Set-Cookie'].is_a?(String)
        @@cookie = response['set-cookie'].split(';')[0] # rubocop:disable Style/ClassVars
        Chef::Log.debug("#{name}##{__method__} cookie: #{@@cookie}") # rubocop:disable Style/ClassVars
      end
      if response.code.to_i >= 400
        error_msg = "#{name}##{__method__}: #{response.code} #{response.message}"
        Chef::Log.fatal(error_msg)
        fail error_msg
      elsif response.body.match(/^.*class=['"]error_msg['"][^>]*>([^<]*)<.*$/)
        error_msg = response.body.gsub(
          /^.*class=['"]error_msg['"][^>]*>([^<]*)<.*$/m,
          '\1'
        )
        Chef::Log.fatal("#{name}##{__method__}: #{error_msg}")
        fail "#{name}##{__method__}"
      elsif response.body.match(/^.*class=['"]standout['"][^>]*>([^<]*)<.*$/)
        response.body.gsub(
          /^.*class=['"]standout['"][^>]*>([^<]*)<.*$/m,
          '\1'
        )
      else
        nil
      end
    end

    def self.get(path, ssl = false)
      request('get', path, nil, ssl)
    end

    def self.post(path, body, ssl = false)
      request('post', path, body, ssl)
    end

    def self.index(ssl = false)
      get('/login.php', ssl)
    end

    def self.setup(body, ssl = false)
      post('/setup.php', body, ssl)
    end

    def self.login(username, password, ssl = false)
      return if @@authenticated # rubocop:disable Style/ClassVars
      index(ssl)
      body = {
        fUsername: username,
        fPassword: password,
        lang: 'en',
        submit: 'Login'
      }
      post('/login.php', body, ssl)
      @@authenticated = true # rubocop:disable Style/ClassVars
    end

    def self.create_admin(username, password, setup_password, ssl = false)
      body = {
        form: 'createadmin',
        setup_password: setup_password,
        fUsername: username,
        fPassword: password,
        fPassword2: password,
        submit: 'Add+Admin'
      }
      setup(body, ssl)
    end

    def self.create_domain(
      domain, description, aliases, mailboxes, login_username, login_password,
      ssl = false
    )
      login(login_username, login_password, ssl)
      body = {
        fDomain: domain,
        fDescription: description,
        fAliases: aliases,
        fMailboxes: mailboxes,
        submit: 'Add+Domain'
      }
      post('/create-domain.php', body, ssl)
    end

    def self.create_mailbox(
      username, domain, password, name, active, mail, login_username,
      login_password, ssl = false
    )
      login(login_username, login_password, ssl)
      body = {
        fUsername: username,
        fDomain: domain,
        fPassword: password,
        fPassword2: password,
        fName: name,
        submit: 'Add+Mailbox'
      }
      body['fActive'] = 'on' if active
      body['fMail'] = 'on' if mail
      post('/create-mailbox.php', body, ssl)
    end

    def self.create_alias(
      address, domain, goto, active, login_username, login_password, ssl = false
    )
      login(login_username, login_password, ssl)
      body = {
        fAddress: address,
        fDomain: domain,
        fGoto: goto,
        submit: 'Add+Alias'
      }
      body['fActive'] = 'on' if active
      post('/create-alias.php', body, ssl)
    end

    def self.create_alias_domain(
      alias_domain, target_domain, active, login_username, login_password,
      ssl = false
    )
      login(login_username, login_password, ssl)
      body = {
        alias_domain: alias_domain,
        target_domain: target_domain,
        submit: 'Add+Alias+Domain'
      }
      body['active'] = '1' if active
      post('/create-alias-domain.php', body, ssl)
    end
  end
end
