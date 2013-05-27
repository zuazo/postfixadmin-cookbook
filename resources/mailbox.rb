
actions :create

attribute :mailbox, :kind_of => String, :name_attribute => true
attribute :password, :kind_of => String, :required => true
attribute :name, :kind_of => Integer, :default => ''
attribute :active, :kind_of => [ TrueClass, FalseClass ], :default => true
attribute :mail, :kind_of => [ TrueClass, FalseClass ], :default => true
attribute :login_username, :kind_of => String, :required => true
attribute :login_password, :kind_of => String, :required => true
attribute :db_user, :kind_of => String
attribute :db_password, :kind_of => String
attribute :db_name, :kind_of => String
attribute :db_host, :kind_of => String
attribute :ssl, :kind_of => [ TrueClass, FalseClass ]


def initialize(*args)
  super
  @action = :create
end

