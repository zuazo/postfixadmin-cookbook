Description
===========
[![Cookbook Version](https://img.shields.io/cookbook/v/postfixadmin.svg)](https://community.opscode.com/cookbooks/postfixadmin)

Installs and configures [PostfixAdmin](http://postfixadmin.sourceforge.net/), a web based interface used to manage mailboxes, virtual domains and aliases.

Also creates the required *MySQL* database and tables. No other databases are supported yet.

The first time it runs, automatically generates some passwords if not specified. Generated passwords are:

## From the PostfixAdmin default recipe

* `setup_password`
* `setup_password_salt`
* `setup_password_encrypted`
* `database/password`

## From the MySQL cookbook

* `mysql/server_root_password`
* `mysql/server_debian_password`
* `mysql/server_repl_password`

Requirements
============

## Platform:

This cookbook has been tested on the following platforms:

* CentOS
* Debian
* Ubuntu

Let me know if you use it successfully on any other platform.

## Cookbooks:

* [apache2](https://community.opscode.com/cookbooks/apache2)
* [ark](https://community.opscode.com/cookbooks/ark)
* [database](https://community.opscode.com/cookbooks/database)
* [mysql](https://community.opscode.com/cookbooks/mysql)

Attributes
==========

<table>
  <tr>
    <th>Attribute</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['version']</code></td>
    <td>PostfixAdmin version</td>
    <td><code>"2.3.7"</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['url']</code></td>
    <td>PostfixAdmin download URL</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['checksum']</code></td>
    <td>PostfixAdmin download file checksum</td>
    <td><code>"ea505281b6c04bda887eb4e6aa6c023b354c4ef4864aa60dcb1425942bf2af63"</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['server_name']</code></td>
    <td>PostfixAdmin server name</td>
    <td><code>"postfixadmin.onddo.com"</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['ssl']</code></td>
    <td>enables HTTPS (with SSL), only tested on Debian and Ubuntu</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['setup_password']</code></td>
    <td>PostfixAdmin Setup Password (required for chef-solo)</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['setup_password_salt']</code></td>
    <td>PostfixAdmin password salt (required for chef-solo)</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['web_server']</code></td>
    <td>Web server to use: <code>"apache"</code> or <code>"false"</code></td>
    <td><code>"apache"</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['setup_password_encrypted']</code></td>
    <td>PostfixAdmin encrypted Password</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['database']['name']</code></td>
    <td>PostfixAdmin database name</td>
    <td><code>"postfix"</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['database']['host']</code></td>
    <td>PostfixAdmin database hostname or IP address</td>
    <td><code>"localhost"</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['database']['user']</code></td>
    <td>PostfixAdmin database login username</td>
    <td><code>"postfix"</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['database']['password']</code></td>
    <td>PostfixAdmin database login password (requried for chef-solo)</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['conf']['encrypt']</code></td>
    <td>The way do you want the passwords to be crypted</td>
    <td><code>"md5crypt"</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['conf']['domain_path']</code></td>
    <td>Whether you want to store the mailboxes per domain</td>
    <td><code>"YES"</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['conf']['domain_in_mailbox']</code></td>
    <td>Whether you want to have the domain in your mailbox</td>
    <td><code>"NO"</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['conf']['fetchmail']</code></td>
    <td>Whether you want fetchmail tab</td>
    <td><code>"NO"</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['map_files']['path']</code></td>
    <td>Path to generate map-files into</td>
    <td><code>"/etc/postfix/tables"</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['map_files']['mode']</code></td>
    <td>Map-files file-mode bits</td>
    <td><code>00640</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['map_files']['owner']</code></td>
    <td>Map-files files owner</td>
    <td><code>"root"</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['map_files']['group']</code></td>
    <td>Map-files files group</td>
    <td><code>"postfix"</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['map_files']['list']</code></td>
    <td>An array with map file names to generate</td>
    <td><code>[<br/>
      &nbsp;&nbsp;"mysql_virtual_alias_maps.cf",<br/>
      &nbsp;&nbsp;"mysql_virtual_alias_domain_maps.cf",<br/>
      &nbsp;&nbsp;"mysql_virtual_alias_domain_catchall_maps.cf",<br/>
      &nbsp;&nbsp;"mysql_virtual_domains_maps.cf",<br/>
      &nbsp;&nbsp;"mysql_virtual_mailbox_maps.cf",<br/>
      &nbsp;&nbsp;"mysql_virtual_alias_domain_mailbox_maps.cf",<br/>
      &nbsp;&nbsp;"mysql_virtual_mailbox_limit_maps.cf"<br/>
      ]</code></td>
  </tr>
</table>

Recipes
=======

## postfixadmin::default

Installs and configures PostfixAdmin.

## postfixadmin::map_files

Installs PostfixAdmin SQL map files to be used by Postfix.

Resources
=========

## postfixadmin_admin[user]

Create or remove a PostfixAdmin admin user. This kind of user is used to create the domains and mailboxes.

### postfixadmin_admin actions

* `create`: Create a PostfixAdmin admin user (default).
* `remove`: Remove a PostfixAdmin admin user.

### postfixadmin_admin attributes

<table>
  <tr>
    <th>Attribute</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td>user</td>
    <td>Username</td>
    <td><em>name attribute</em></td>
  </tr>
  <tr>
    <td>password</td>
    <td>Password</td>
    <td><code>"p@ssw0rd1"</code></td>
  </tr>
  <tr>
    <td>setup_password</td>
    <td>PostfixAdmin Setup Password</td>
    <td><code>node['postfixadmin']['setup_password']</code></td>
  </tr>
  <tr>
    <td>db_user</td>
    <td>Database username</td>
    <td><code>node['postfixadmin']['database']['user']</code></td>
  </tr>
  <tr>
    <td>db_password</td>
    <td>Database password</td>
    <td><code>node['postfixadmin']['database']['password']</code></td>
  </tr>
  <tr>
    <td>db_name</td>
    <td>Database name</td>
    <td><code>node['postfixadmin']['database']['name']</code></td>
  </tr>
  <tr>
    <td>db_host</td>
    <td>Database hostname</td>
    <td><code>node['postfixadmin']['database']['host']</code></td>
  </tr>
  <tr>
    <td>ssl</td>
    <td>Whether to use SSL on HTTP requests</td>
    <td><code>node['postfixadmin']['ssl']</code></td>
  </tr>
</table>

### postfixadmin_admin example

```ruby
postfixadmin_admin 'admin@admindomain.com' do
  password 'sup3r-s3cr3t-p4ss'
  action :create
end
```

## postfixadmin_domain[domain]

Create domains.

### postfixadmin_domain actions

* `create`

### postfixadmin_domain attributes

<table>
  <tr>
    <th>Attribute</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td>domain</td>
    <td>Domain name</td>
    <td><em>name attribute</em></td>
  </tr>
  <tr>
    <td>description</td>
    <td>Domain description</td>
    <td><code>""</code></td>
  </tr>
  <tr>
    <td>aliases</td>
    <td>Maximum number of aliases</td>
    <td><code>10</code></td>
  </tr>
  <tr>
    <td>mailboxes</td>
    <td>Maximum number of mailboxes</td>
    <td><code>10</code></td>
  </tr>
  <tr>
    <td>login_username</td>
    <td>Admin user to use</td>
    <td><em>required</em></td>
  </tr>
  <tr>
    <td>login_password</td>
    <td>Admin password </td>
    <td><em>required</em></td>
  </tr>
  <tr>
    <td>db_user</td>
    <td>Database username</td>
    <td><code>node['postfixadmin']['database']['user']</code></td>
  </tr>
  <tr>
    <td>db_password</td>
    <td>Database password</td>
    <td><code>node['postfixadmin']['database']['password']</code></td>
  </tr>
  <tr>
    <td>db_name</td>
    <td>Database name</td>
    <td><code>node['postfixadmin']['database']['name']</code></td>
  </tr>
  <tr>
    <td>db_host</td>
    <td>Database hostname</td>
    <td><code>node['postfixadmin']['database']['host']</code></td>
  </tr>
  <tr>
    <td>ssl</td>
    <td>Whether to use SSL on HTTP requests</td>
    <td><code>node['postfixadmin']['ssl']</code></td>
  </tr>
</table>

### postfixadmin_domain example

```ruby
# admin user copied from the previous example
postfixadmin_domain 'foobar.com' do
  login_username 'admin@admindomain.com'
  login_password 'sup3r-s3cr3t-p4ss'
end
```

## postfixadmin_mailbox[mailbox]

Create a mailbox.

### postfixadmin_mailbox actions

* `create`

### postfixadmin_mailbox attributes

<table>
  <tr>
    <th>Attribute</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td>mailbox</td>
    <td>Mailbox address to create</td>
    <td><em>name attribute</em></td>
  </tr>
  <tr>
    <td>password</td>
    <td>Mailbox password</td>
    <td><em>required</em></td>
  </tr>
  <tr>
    <td>name</td>
    <td>The name of the mailbox owner</td>
    <td><code>""</code></td>
  </tr>
  <tr>
    <td>active</td>
    <td>Active status</td>
    <td><code>true</code></td>
  </tr>
  <tr>
    <td>mail</td>
    <td>Whether to send a welcome email</td>
    <td><code>false</code></td>
  </tr>
  <tr>
    <td>login_username</td>
    <td>Admin user to use</td>
    <td><em>required</em></td>
  </tr>
  <tr>
    <td>login_password</td>
    <td>Admin password </td>
    <td><em>required</em></td>
  </tr>
  <tr>
    <td>db_user</td>
    <td>Database username</td>
    <td><code>node['postfixadmin']['database']['user']</code></td>
  </tr>
  <tr>
    <td>db_password</td>
    <td>Database password</td>
    <td><code>node['postfixadmin']['database']['password']</code></td>
  </tr>
  <tr>
    <td>db_name</td>
    <td>Database name</td>
    <td><code>node['postfixadmin']['database']['name']</code></td>
  </tr>
  <tr>
    <td>db_host</td>
    <td>Database hostname</td>
    <td><code>node['postfixadmin']['database']['host']</code></td>
  </tr>
  <tr>
    <td>ssl</td>
    <td>Whether to use SSL on HTTP requests</td>
    <td><code>node['postfixadmin']['ssl']</code></td>
  </tr>
</table>

### postfixadmin_mailbox example

```ruby
# admin user copied from the previous example
postfixadmin_mailbox 'bob@foobar.com' do
  password 'alice'
  login_username 'admin@admindomain.com'
  login_password 'sup3r-s3cr3t-p4ss'
end
```

## postfixadmin_alias[address]

Create mailbox aliases.

### postfixadmin_alias actions

* `create`

### postfixadmin_alias attributes

<table>
  <tr>
    <th>Attribute</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td>address</td>
    <td>Alias address</td>
    <td><em>name attribute</em></td>
  </tr>
  <tr>
    <td>goto</td>
    <td>Destination mailbox address</td>
    <td><em>required</em></td>
  </tr>
  <tr>
    <td>active</td>
    <td>Active status</td>
    <td><code>true</code></td>
  </tr>
  <tr>
    <td>login_username</td>
    <td>Admin user to use</td>
    <td><em>required</em></td>
  </tr>
  <tr>
    <td>login_password</td>
    <td>Admin password </td>
    <td><em>required</em></td>
  </tr>
  <tr>
    <td>db_user</td>
    <td>Database username</td>
    <td><code>node['postfixadmin']['database']['user']</code></td>
  </tr>
  <tr>
    <td>db_password</td>
    <td>Database password</td>
    <td><code>node['postfixadmin']['database']['password']</code></td>
  </tr>
  <tr>
    <td>db_name</td>
    <td>Database name</td>
    <td><code>node['postfixadmin']['database']['name']</code></td>
  </tr>
  <tr>
    <td>db_host</td>
    <td>Database hostname</td>
    <td><code>node['postfixadmin']['database']['host']</code></td>
  </tr>
  <tr>
    <td>ssl</td>
    <td>Whether to use SSL on HTTP requests</td>
    <td><code>node['postfixadmin']['ssl']</code></td>
  </tr>
</table>

### postfixadmin_alias example

```ruby
# admin user copied from the previous example
postfixadmin_alias 'billing@foobar.com' do
  goto 'bob@foobar.com'
  login_username 'admin@admindomain.com'
  login_password 'sup3r-s3cr3t-p4ss'
end
```

## postfixadmin_alias_domain[address]

Create domain aliases. The `alias_domain` must already exist.

### postfixadmin_alias_domain actions

* `create`

### postfixadmin_alias_domain attributes

<table>
  <tr>
    <th>Attribute</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td>alias_domain</td>
    <td>Alias domain</td>
    <td><em>name attribute</em></td>
  </tr>
  <tr>
    <td>target_domain</td>
    <td>Target domain</td>
    <td><em>required</em></td>
  </tr>
  <tr>
    <td>active</td>
    <td>Active status</td>
    <td><code>true</code></td>
  </tr>
  <tr>
    <td>login_username</td>
    <td>Admin user to use</td>
    <td><em>required</em></td>
  </tr>
  <tr>
    <td>login_password</td>
    <td>Admin password </td>
    <td><em>required</em></td>
  </tr>
  <tr>
    <td>db_user</td>
    <td>Database username</td>
    <td><code>node['postfixadmin']['database']['user']</code></td>
  </tr>
  <tr>
    <td>db_password</td>
    <td>Database password</td>
    <td><code>node['postfixadmin']['database']['password']</code></td>
  </tr>
  <tr>
    <td>db_name</td>
    <td>Database name</td>
    <td><code>node['postfixadmin']['database']['name']</code></td>
  </tr>
  <tr>
    <td>db_host</td>
    <td>Database hostname</td>
    <td><code>node['postfixadmin']['database']['host']</code></td>
  </tr>
  <tr>
    <td>ssl</td>
    <td>Whether to use SSL on HTTP requests</td>
    <td><code>node['postfixadmin']['ssl']</code></td>
  </tr>
</table>

### postfixadmin_alias_domain example

```ruby
# admin user copied from the previous example
postfixadmin_alias_domain 'aliasdomain.com' do
  target_domain 'foobar.com'
  login_username 'admin@admindomain.com'
  login_password 'sup3r-s3cr3t-p4ss'
end
```

Usage Example
=============

## Including in a Cookbook Recipe

A complete example:

```ruby
include_recipe 'postfixadmin::default'
include_recipe 'postfixadmin::map_files'
# or include them in your run-list

postfixadmin_admin 'admin@admindomain.com' do
  password 'sup3r-s3cr3t-p4ss'
  action :create
end

postfixadmin_domain 'foobar.com' do
  login_username 'admin@admindomain.com'
  login_password 'sup3r-s3cr3t-p4ss'
end

postfixadmin_mailbox 'bob@foobar.com' do
  password 'alice'
  login_username 'admin@admindomain.com'
  login_password 'sup3r-s3cr3t-p4ss'
end

postfixadmin_alias 'billing@foobar.com' do
  goto 'bob@foobar.com'
  login_username 'admin@admindomain.com'
  login_password 'sup3r-s3cr3t-p4ss'
end

postfixadmin_alias_domain 'aliasdomain.com' do
  target_domain 'foobar.com'
  login_username 'admin@admindomain.com'
  login_password 'sup3r-s3cr3t-p4ss'
end
```

Don't forget to include the `postfixadmin` cookbook as a dependency in the metadata.

```ruby
# metadata.rb
[...]

depends 'postfixadmin'
```

## Including in the Run List

Another alternative is to include the recipes in your Run List.

```json
{
  "name": "mail.onddo.com",
  [...]
  "run_list": [
    [...]
    "recipe[postfixadmin]",
    "recipe[postfixadmin::map_files]"
  ]
}
```

Testing
=======

## Requirements

* `vagrant`
* `berkshelf` >= `2.0.0`
* `test-kitchen` >= `1.2`
* `kitchen-vagrant` >= `0.10.0`

## Running the tests

```bash
$ kitchen test
$ kitchen verify
[...]
```

Contributing
============

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github


License and Author
==================

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | [Xabier de Zuazo](https://github.com/zuazo) (<xabier@onddo.com>)
| **Contributor:**     | [chrludwig](https://github.com/chrludwig)
| **Contributor:**     | [MATSUI Shinsuke (poppen)](https://github.com/poppen)
| **Copyright:**       | Copyright (c) 2013-2014 Onddo Labs, SL. (www.onddo.com)
| **License:**         | Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
        http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

