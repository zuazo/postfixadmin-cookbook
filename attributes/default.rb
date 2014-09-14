# encoding: UTF-8

default['postfixadmin']['version'] = '2.3.7'
default['postfixadmin']['url'] =
  'http://downloads.sourceforge.net/project/postfixadmin/postfixadmin/'\
  "postfixadmin-#{node['postfixadmin']['version']}/"\
  "postfixadmin-#{node['postfixadmin']['version']}.tar.gz"
default['postfixadmin']['checksum'] =
  '761074e711ab618deda425dc013133b9d5968e0859bb883f10164061fd87006e'

default['postfixadmin']['port'] = nil # calculated
default['postfixadmin']['server_name'] = node['fqdn'] || 'postfixadmin.local'
default['postfixadmin']['server_aliases'] = []
default['postfixadmin']['headers'] = {}
default['postfixadmin']['ssl'] = false
default['postfixadmin']['encrypt_attributes'] = false
default['postfixadmin']['setup_password'] = nil # randomly generated
default['postfixadmin']['setup_password_salt'] = nil # required for chef-solo
default['postfixadmin']['setup_password_encrypted'] = nil # randomly generated

default['postfixadmin']['web_server'] = 'apache'

default['postfixadmin']['database']['type'] = 'mysql'
default['postfixadmin']['database']['name'] = 'postfix'
default['postfixadmin']['database']['host'] = 'localhost'
default['postfixadmin']['database']['user'] = 'postfix'
default['postfixadmin']['database']['password'] = nil # randomly generated
