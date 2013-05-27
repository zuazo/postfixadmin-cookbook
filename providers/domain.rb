
def whyrun_supported?
  true
end

action :create do

  new_resource = @new_resource
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

  converge_by("Create #{new_resource}") do
    db = PostfixAdmin::MySQL.new(db_user, db_password, db_name, db_host)
    ruby_block "create domain #{new_resource.domain}" do
      block do
        result = PostfixAdmin::API.createDomain(new_resource.domain, description, aliases, mailboxes, login_username, login_password, ssl)
        Chef::Log.info("Created #{new_resource}: #{result}")
      end
      not_if do db.domainExists?(new_resource.domain) end
      action :create
    end
  end

end

