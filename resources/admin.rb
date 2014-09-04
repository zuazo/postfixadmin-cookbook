# encoding: UTF-8

actions :create, :remove

attribute :user, kind_of: String, name_attribute: true
attribute :password, kind_of: String, default: 'p@ssw0rd1'
attribute :setup_password, kind_of: String
attribute :db_user, kind_of: String
attribute :db_password, kind_of: String
attribute :db_name, kind_of: String
attribute :db_host, kind_of: String
attribute :ssl, kind_of: [TrueClass, FalseClass]

def initialize(*args)
  super
  @action = :create
end
