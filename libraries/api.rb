# encoding: UTF-8

module PostfixAdmin
  # Static class to make PostfixAdmin API calls
  class API
    def initialize(ssl = false, username = nil, password = nil)
      @http = API::HTTP.new(username, password, ssl)
    end

    def create_admin(username, password, setup_password)
      @http.setup(username, password, setup_password)
    end

    def create_domain(domain, description, aliases, mailboxes)
      body = {
        fDomain: domain,
        fDescription: description,
        fAliases: aliases,
        fMailboxes: mailboxes,
        submit: 'Add+Domain'
      }
      @http.post('/create-domain.php', body)
    end

    # rubocop:disable Metrics/ParameterLists
    def create_mailbox(username, domain, password, name, active, mail)
      # rubocop:enable Metrics/ParameterLists
      body = {
        fUsername: username,
        fDomain: domain,
        fPassword: password, fPassword2: password,
        fName: name,
        submit: 'Add+Mailbox'
      }
      body['fActive'] = 'on' if active
      body['fMail'] = 'on' if mail
      @http.post('/create-mailbox.php', body)
    end

    def create_alias(address, domain, goto, active)
      body = {
        fAddress: address,
        fDomain: domain,
        fGoto: goto,
        submit: 'Add+Alias'
      }
      body['fActive'] = 'on' if active
      @http.post('/create-alias.php', body)
    end

    def create_alias_domain(alias_domain, target_domain, active)
      body = {
        alias_domain: alias_domain,
        target_domain: target_domain,
        submit: 'Add+Alias+Domain'
      }
      body['active'] = '1' if active
      @http.post('/create-alias-domain.php', body)
    end
  end
end
