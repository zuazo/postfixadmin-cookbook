
default['postfixadmin']['path'] = '/var/www/postfixadmin'
default['postfixadmin']['version'] = '2.3.6'
default['postfixadmin']['url'] = "http://downloads.sourceforge.net/project/postfixadmin/postfixadmin/postfixadmin-#{node['postfixadmin']['version']}/postfixadmin-#{node['postfixadmin']['version']}.tar.gz"
default['postfixadmin']['checksum'] = 'ea505281b6c04bda887eb4e6aa6c023b354c4ef4864aa60dcb1425942bf2af63'

default['postfixadmin']['database']['name'] = 'postfix'
default['postfixadmin']['database']['host'] = 'localhost'
default['postfixadmin']['database']['user'] = 'postfix'
default['postfixadmin']['database']['password'] = nil # randomly generated

