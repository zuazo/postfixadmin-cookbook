
def whyrun_supported?
  true
end

action :create do
  new_resource = @new_resource
  domain = new_resource.domain
  description = new_resource.description
  aliases = new_resource.aliases
  mailboxes = new_resource.mailboxes
  login_username = new_resource.login_username
  login_password = new_resource.login_password
  db_user = new_resource.db_user || node['postfixadmin']['database']['user']
  db_password = new_resource.db_password || node['postfixadmin']['database']['password']
  db_name = new_resource.db_name || node['postfixadmin']['database']['name']
  db_host = new_resource.db_host || node['postfixadmin']['database']['host']
  ssl = new_resource.ssl || node['postfixadmin']['ssl']

  db = PostfixAdmin::MySQL.new(db_user, db_password, db_name, db_host)
  return if db.domainExists?(domain)
  converge_by("Create #{new_resource}") do
    ruby_block "create domain #{domain}" do
      block do
        result = PostfixAdmin::API.createDomain(domain, description, aliases, mailboxes, login_username, login_password, ssl)
        Chef::Log.info("Created #{new_resource}: #{result}")
      end
      action :create
    end
  end

end

