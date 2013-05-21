
default['postfixadmin']['map_files']['path'] = '/etc/postfix/sql'
default['postfixadmin']['map_files']['mode'] = '00644'
default['postfixadmin']['map_files']['owner'] = 'root'
default['postfixadmin']['map_files']['group'] = 'root' # TODO: this should not be root, and mode should be more restritive

default['postfixadmin']['map_files']['list'] = [
  'mysql_virtual_alias_maps.cf',
  'mysql_virtual_alias_domain_maps.cf',
  'mysql_virtual_alias_domain_catchall_maps.cf',
  'mysql_virtual_domains_maps.cf',
  'mysql_virtual_mailbox_maps.cf',
  'mysql_virtual_alias_domain_mailbox_maps.cf',
  'mysql_virtual_mailbox_limit_maps.cf',
]

