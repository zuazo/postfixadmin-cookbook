
def whyrun_supported?
  true
end

action :create do

  setup_password = new_resource.setup_password || node['postfixadmin']['setup_password']
  db_user = new_resource.db_user || node['postfixadmin']['database']['user']
  db_password = new_resource.db_password || node['postfixadmin']['database']['password']
  db_name = new_resource.db_name || node['postfixadmin']['database']['name']
  db_host = new_resource.db_host || node['postfixadmin']['database']['host']

  new_resource = @new_resource
  converge_by("Create #{new_resource}") do
    db = PostfixAdmin::MySQL.new(db_user, db_password, db_name, db_host)
    ruby_block "create admin user #{new_resource.user}" do
      block do
        result = PostfixAdmin::API.createAdmin(new_resource.user, new_resource.password, setup_password)
        Chef::Log.info("Create #{new_resource}: #{result}")
      end
      action :create
      not_if do db.adminExists?(new_resource.user) end
    end
  end

end

