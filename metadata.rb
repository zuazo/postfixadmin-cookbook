name             'postfixadmin'
maintainer       'Onddo Labs, Sl.'
maintainer_email 'team@onddo.com'
license          'Apache 2.0'
description      'Installs and configures PostfixAdmin, a web based interface used to manage mailboxes, virtual domains and aliases.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0' # WiP

supports 'debian'
supports 'centos'
supports 'ubuntu'

depends 'apache2'
depends 'ark'
depends 'database'
depends 'mysql'

recipe 'postfixadmin::default', 'Installs and configures PostfixAdmin'
recipe 'postfixadmin::map_files', 'Installs PostfixAdmin SQL map files to be used by Postfix'

provides 'postfixadmin_admin'
provides 'postfixadmin_alias'
provides 'postfixadmin_domain'
provides 'postfixadmin_mailbox'
# Commented until 11.0.10 server release (CHEF-3976)
# provides 'postfixadmin_admin[user]'
# provides 'postfixadmin_alias[address]'
# provides 'postfixadmin_domain[domain]'
# provides 'postfixadmin_mailbox[mailbox]'

attribute 'postfixadmin/version',
  :display_name => 'postfixadmin version',
  :description => 'PostfixAdmin version',
  :type => 'string',
  :required => 'optional',
  :default => '"2.3.6"'
  
attribute 'postfixadmin/url',
  :display_name => 'postfixadmin URL',
  :description => 'PostfixAdmin download URL',
  :calculated => true,
  :type => 'string',
  :required => 'optional'

attribute 'postfixadmin/checksum',
  :display_name => 'postfixadmin checksum',
  :description => 'PostfixAdmin download file checksum',
  :type => 'string',
  :required => 'optional',
  :default => '"ea505281b6c04bda887eb4e6aa6c023b354c4ef4864aa60dcb1425942bf2af63"'

attribute 'postfixadmin/server_name',
  :display_name => 'server name',
  :description => 'PostfixAdmin server name',
  :type => 'string',
  :required => 'recommended',
  :default => '"postfixadmin.onddo.com"'

attribute 'postfixadmin/ssl',
  :display_name => 'enable ssl',
  :description => 'enables HTTPS (with SSL), only tested on Debian and Ubuntu',
  :choice => [ 'true', 'false' ],
  :type => 'string',
  :required => 'optional',
  :default => 'false'

attribute 'postfixadmin/setup_password',
  :display_name => 'postfixadmin setup_password',
  :description => 'PostfixAdmin Setup Password (required for chef-solo)',
  :calculated => true,
  :type => 'string',
  :required => 'optional'

attribute 'postfixadmin/setup_password_salt',
  :display_name => 'postfixadmin password_salt',
  :description => 'PostfixAdmin password salt (required for chef-solo)',
  :calculated => true,
  :type => 'string',
  :required => 'optional'

attribute 'postfixadmin/setup_password_encrypted',
  :display_name => 'postfixadmin password_encrypted',
  :description => 'PostfixAdmin encrypted Password',
  :calculated => true,
  :type => 'string',
  :required => 'optional'

attribute 'postfixadmin/web_server',
  :display_name => 'Web Server',
  :description => 'Web server to use: apache or false',
  :choice => [ '"apache"', '"false"' ],
  :type => 'string',
  :required => 'optional',
  :default => '"apache"'

grouping 'postfixadmin/database',
 :title => 'postfixadmin database',
 :description => 'PostfixAdmin database configuration options'

attribute 'postfixadmin/database/name',
  :display_name => 'database name',
  :description => 'PostfixAdmin database name',
  :type => 'string',
  :required => 'optional',
  :default => '"postfix"'

attribute 'postfixadmin/database/host',
  :display_name => 'database host',
  :description => 'PostfixAdmin database hostname or IP address',
  :type => 'string',
  :required => 'optional',
  :default => '"localhost"'

attribute 'postfixadmin/database/user',
  :display_name => 'database user',
  :description => 'PostfixAdmin database login username',
  :type => 'string',
  :required => 'optional',
  :default => '"postfix"'

attribute 'postfixadmin/database/password',
  :display_name => 'database password',
  :description => 'PostfixAdmin database login password (required for chef-solo)',
  :calculated => true,
  :type => 'string',
  :required => 'optional'

grouping 'postfixadmin/conf',
 :title => 'postfixadmin configuration',
 :description => 'PostfixAdmin configuration options (config.local.php)'

attribute 'postfixadmin/conf/encrypt',
  :display_name => 'encryption configuration',
  :description => 'The way do you want the passwords to be crypted',
  :type => 'string',
  :required => 'optional',
  :default => '"md5crypt"'

attribute 'postfixadmin/conf/domain_path',
  :display_name => 'domain path configuration',
  :description => 'Whether you want to store the mailboxes per domain',
  :choice => [ '"YES"', '"NO"' ],
  :type => 'string',
  :required => 'optional',
  :default => '"YES"'

attribute 'postfixadmin/conf/domain_in_mailbox',
  :display_name => 'domain in mailbox configuration',
  :description => 'Whether you want to have the domain in your mailbox',
  :choice => [ '"YES"', '"NO"' ],
  :type => 'string',
  :required => 'optional',
  :default => '"NO"'

attribute 'postfixadmin/conf/fetchmail',
  :display_name => 'enable fetchmail',
  :description => 'Whether you want fetchmail tab',
  :choice => [ '"YES"', '"NO"' ],
  :type => 'string',
  :required => 'optional',
  :default => '"NO"'

grouping 'postfixadmin/map_files',
 :title => 'postfixadmin map files',
 :description => 'PostfixAdmin map-files configuration options'

attribute 'postfixadmin/map_files/path',
  :display_name => 'map files path',
  :description => 'Path to generate map-files into',
  :type => 'string',
  :required => 'optional',
  :default => '"/etc/postfix/tables"'

attribute 'postfixadmin/map_files/mode',
  :display_name => 'map files mode',
  :description => 'Map-files file-mode bits',
  :type => 'string',
  :required => 'optional',
  :default => '00640'

attribute 'postfixadmin/map_files/owner',
  :display_name => 'map files owner',
  :description => 'Map-files files owner',
  :type => 'string',
  :required => 'optional',
  :default => '"root"'

attribute 'postfixadmin/map_files/group',
  :display_name => 'map files group',
  :description => 'Map-files files group',
  :type => 'string',
  :required => 'optional',
  :default => '"postfix"'

attribute 'postfixadmin/map_files/list',
  :display_name => 'map files list',
  :description => 'An array with map file names to generate',
  :type => 'array',
  :required => 'optional',
  :default => [
    'mysql_virtual_alias_maps.cf',
    'mysql_virtual_alias_domain_maps.cf',
    'mysql_virtual_alias_domain_catchall_maps.cf',
    'mysql_virtual_domains_maps.cf',
    'mysql_virtual_mailbox_maps.cf',
    'mysql_virtual_alias_domain_mailbox_maps.cf',
    'mysql_virtual_mailbox_limit_maps.cf',
  ]

