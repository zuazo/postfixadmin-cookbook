
def whyrun_supported?
  true
end

action :create do
  new_resource = @new_resource
  mailbox = new_resource.name
  username, domain = mailbox.split('@', 2)
  if domain.nil?
    raise Chef::Exceptions::ArgumentError, 'Could not get the domain name from the mailbox argument, it should have the following format: user@domain.tld'
  end
  password = new_resource.password
  name = new_resource.name
  active = new_resource.active
  mail = new_resource.mail
  login_username = new_resource.login_username
  login_password = new_resource.login_password
  db_user = new_resource.db_user || node['postfixadmin']['database']['user']
  db_password = new_resource.db_password || node['postfixadmin']['database']['password']
  db_name = new_resource.db_name || node['postfixadmin']['database']['name']
  db_host = new_resource.db_host || node['postfixadmin']['database']['host']
  ssl = new_resource.ssl || node['postfixadmin']['ssl']

  db = PostfixAdmin::MySQL.new(db_user, db_password, db_name, db_host)
  next if db.mailboxExists?(mailbox)
  converge_by("Create #{new_resource}") do
    ruby_block "create mailbox #{mailbox}" do
      block do
        result = PostfixAdmin::API.createMailbox(username, domain, password, name, active, mail, login_username, login_password, ssl)
        Chef::Log.info("Created #{new_resource}: #{result}")
      end
      action :create
    end
  end

end

