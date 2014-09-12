Description
===========
[![Cookbook Version](https://img.shields.io/cookbook/v/postfixadmin.svg?style=flat)](https://supermarket.getchef.com/cookbooks/postfixadmin)
[![Dependency Status](http://img.shields.io/gemnasium/onddo/postfixadmin-cookbook.svg?style=flat)](https://gemnasium.com/onddo/postfixadmin-cookbook)
[![Code Climate](http://img.shields.io/codeclimate/github/onddo/postfixadmin-cookbook.svg?style=flat)](https://codeclimate.com/github/onddo/postfixadmin-cookbook)
[![Build Status](http://img.shields.io/travis/onddo/postfixadmin-cookbook.svg?style=flat)](https://travis-ci.org/onddo/postfixadmin-cookbook)

Installs and configures [PostfixAdmin](http://postfixadmin.sourceforge.net/), a web based interface used to manage mailboxes, virtual domains and aliases.

Also creates the required *MySQL* or *PostgreSQL* database and tables.

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

## From the PostgreSQL cookbook

* `postgresql/password/postgres`

Requirements
============

## Supported Platforms

This cookbook has been tested on the following platforms:

* CentOS
* Debian
* Ubuntu

Please, [let us know](https://github.com/onddo/postfixadmin-cookbook/issues/new?title=I%20have%20used%20it%20successfully%20on%20...) if you use it successfully on any other platform.

## Required Cookbooks

* [apache2](https://supermarket.getchef.com/cookbooks/apache2)
* [ark](https://supermarket.getchef.com/cookbooks/ark)
* [database](https://supermarket.getchef.com/cookbooks/database)
* [mysql](https://supermarket.getchef.com/cookbooks/mysql) (recommended)
* [postgresql (>= 1.0.0)](https://supermarket.getchef.com/cookbooks/postgresql) (recommended)
* [ssl_certificate](https://supermarket.getchef.com/cookbooks/ssl_certificate)

## Required Applications

* Ruby `1.9.3` or higher.

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
    <td><code>"761074e711ab618deda425dc013133b9d5968e0859bb883f10164061fd87006e"</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['port']</code></td>
    <td>PostfixAdmin listen port</td>
    <td><em>calculated: </em><code>"80"</code><em> or </em><code>"443"</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['server_name']</code></td>
    <td>PostfixAdmin server name</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['server_aliases']</code></td>
    <td>PostfixAdmin server aliases</td>
    <td><code>[]</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['headers']</code></td>
    <td>PostfixAdmin HTTP headers to set as hash</td>
    <td><code>{}</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['ssl']</code></td>
    <td>enables HTTPS (with SSL)</td>
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
    <td><code>node['postfixadmin']['database']['type']</code></td>
    <td>PostfixAdmin database type. Possible values are: <code>"mysql"</code>, <code>"postgresql"</code></td>
    <td><code>"mysql"</code></td>
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
    <td><code>node['postfixadmin']['packages']['requirements']</code></td>
    <td>PostfixAdmin required packages array</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['packages']['mysql']</code></td>
    <td>PostfixAdmin required packages array for MySQL support</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['packages']['postgresql']</code></td>
    <td>PostfixAdmin required packages array for PostgreSQL support</td>
    <td><em>calculated</em></td>
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
      &nbsp;&nbsp;"db_virtual_alias_maps.cf",<br/>
      &nbsp;&nbsp;"db_virtual_alias_domain_maps.cf",<br/>
      &nbsp;&nbsp;"db_virtual_alias_domain_catchall_maps.cf",<br/>
      &nbsp;&nbsp;"db_virtual_domains_maps.cf",<br/>
      &nbsp;&nbsp;"db_virtual_mailbox_maps.cf",<br/>
      &nbsp;&nbsp;"db_virtual_alias_domain_mailbox_maps.cf",<br/>
      &nbsp;&nbsp;"db_virtual_mailbox_limit_maps.cf"<br/>
      ]</code></td>
  </tr>
</table>

## The HTTPS Certificate

This cookbook uses the [`ssl_certificate`](https://supermarket.getchef.com/cookbooks/ssl_certificate) cookbook to create the HTTPS certificate. The namespace used is `node['postfixadmin']`. For example:

```ruby
node.default['postfixadmin']['common_name'] = 'postfixadmin.example.com'
include_recipe 'postfixadmin'
```

See the [`ssl_certificate` namespace documentation](https://supermarket.getchef.com/cookbooks/ssl_certificate#namespaces) for more information.

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
* `foodcritic`
* `rubocop`
* `berkshelf`
* `test-kitchen`
* `kitchen-vagrant`

## Running the tests

```bash
$ kitchen test
$ kitchen verify
[...]
```

## ChefSpec Matchers

### create_postfixadmin_admin(user)

Assert that the *Chef Run* creates a PostfixAdmin admin user.

```ruby
expect(chef_run).to create_postfixadmin_admin(user)
```

### remove_postfixadmin_admin(path)

Assert that the *Chef Run* removes a PostfixAdmin admin user.

```ruby
expect(chef_run).to remove_postfixadmin_admin(user)
```

### create_postfixadmin_alias(address)

Assert that the *Chef Run* creates a PostfixAdmin alias.

```ruby
expect(chef_run).to create_postfixadmin_alias(address)
```

### create_postfixadmin_alias_domain(alias_domain)

Assert that the *Chef Run* creates a PostfixAdmin alias domain.

```ruby
expect(chef_run).to create_postfixadmin_alias_domain(alias_domain)
```

### create_postfixadmin_domain(domain)

Assert that the *Chef Run* creates a PostfixAdmin domain.

```ruby
expect(chef_run).to create_postfixadmin_domain(domain)
```

### create_postfixadmin_mailbox(mailbox)

Assert that the *Chef Run* creates a PostfixAdmin mailbox.

```ruby
expect(chef_run).to create_postfixadmin_mailbox(mailbox)
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

