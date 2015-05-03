Description
===========
[![Cookbook Version](https://img.shields.io/cookbook/v/postfixadmin.svg?style=flat)](https://supermarket.getchef.com/cookbooks/postfixadmin)
[![Dependency Status](http://img.shields.io/gemnasium/onddo/postfixadmin-cookbook.svg?style=flat)](https://gemnasium.com/onddo/postfixadmin-cookbook)
[![Code Climate](http://img.shields.io/codeclimate/github/onddo/postfixadmin-cookbook.svg?style=flat)](https://codeclimate.com/github/onddo/postfixadmin-cookbook)
[![Build Status](http://img.shields.io/travis/onddo/postfixadmin-cookbook.svg?style=flat)](https://travis-ci.org/onddo/postfixadmin-cookbook)

Installs and configures [PostfixAdmin](http://postfixadmin.sourceforge.net/), a web based interface used to manage mailboxes, virtual domains and aliases.

Also creates the required *MySQL* or *PostgreSQL* database and tables.

Table of Contents
=================

- [Requirements](#requirements)
- [Generated Passwords](#generated-passwords)
- [Attributes](#attributes)
  - [The HTTPS Certificate](#the-https-certificate)
  - [Encrypted Attributes](#encrypted-attributes)
- [Recipes](#recipes)
  - [postfixadmin::default](#postfixadmindefault)
  - [postfixadmin::map_files](#postfixadminmap_files)
  - [postfixadmin::mysql](#postfixadminmysql)
  - [postfixadmin::postgresql](#postfixadminpostgresql)
- [Resources](#resources)
  - [postfixadmin_admin[user]](#postfixadmin_adminuser)
  - [postfixadmin_domain[domain]](#postfixadmin_domaindomain)
  - [postfixadmin_mailbox[mailbox]](#postfixadmin_mailboxmailbox)
  - [postfixadmin_alias[address]](#postfixadmin_aliasaddress)
  - [postfixadmin_alias_domain[address]](#postfixadmin_alias_domainaddress)
- [Usage Example](#usage-example)
  - [Including in a Cookbook Recipe](#including-in-a-cookbook-recipe)
  - [Including in the Run List](#including-in-the-run-list)
- [PostgreSQL Support](#postgresql-support)
  - [PostgreSQL Support on Debian and Ubuntu](#postgresql-support-on-debian-and-ubuntu)
  - [PostgreSQL Versions < 9.3](#postgresql-versions--93)
- [Testing](#testing)
  - [ChefSpec Matchers](#chefspec-matchers)
- [Contributing](#contributing)
- [TODO](#todo)
- [License and Author](#license-and-author)

Requirements
============

## Supported Platforms

This cookbook has been tested on the following platforms:

* Amazon Linux
* CentOS
* Debian
* Fedora
* Ubuntu

Please, [let us know](https://github.com/onddo/postfixadmin-cookbook/issues/new?title=I%20have%20used%20it%20successfully%20on%20...) if you use it successfully on any other platform.

## Required Cookbooks

* [apache2](https://supermarket.getchef.com/cookbooks/apache2)
* [ark](https://supermarket.getchef.com/cookbooks/ark)
* [database](https://supermarket.getchef.com/cookbooks/database)
* [encrypted_attributes (~> 0.2)](https://supermarket.getchef.com/cookbooks/encrypted_attributes)
* [mysql](https://supermarket.getchef.com/cookbooks/mysql)
* [nginx](https://supermarket.getchef.com/cookbooks/nginx)
* [php](https://supermarket.getchef.com/cookbooks/php)
* [php-fpm](https://supermarket.getchef.com/cookbooks/php-fpm)
* [postgresql (>= 1.0.0)](https://supermarket.getchef.com/cookbooks/postgresql)
* [ssl_certificate](https://supermarket.getchef.com/cookbooks/ssl_certificate)
* [yum-epel](https://supermarket.getchef.com/cookbooks/yum-epel)

## Required Applications

* Ruby `1.9.3` or higher.

## Other Requirements

On RedHat based platforms, you need to disable or configure SELinux correctly to work with `mysql` cookbook. You can use the `selinux::disabled` recipe for that.

Generated Passwords
===================

The first time it runs, automatically generates some passwords if not specified. Generated passwords are:

## From the PostfixAdmin Default Recipe

* `postfixadmin/setup_password`
* `postfixadmin/setup_password_salt`
* `postfixadmin/setup_password_encrypted`
* `postfixadmin/database/password`

## When MySQL Is Used

* `postfixadmin/mysql/server_root_password`

## When PostgreSQL Is Used

* `postgresql/password/postgres`

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
    <td><code>node['postfixadmin']['encrypt_attributes']</code></td>
    <td>Whether to encrypt PostfixAdmin attributes containing credential secrets.</td>
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
    <td>Web server to use: <code>"apache"</code>, <code>"nginx"</code> or <code>false</code></td>
    <td><code>"apache"</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['setup_password_encrypted']</code></td>
    <td>PostfixAdmin encrypted Password</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['database']['type']</code></td>
    <td>PostfixAdmin database type. Possible values are: <code>"mysql"</code>, <code>"postgresql" (Please, see <a href="#postgresql-support">below<a/>)</code></td>
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
    <td><code>"127.0.0.1"</code></td>
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
    <td><code>node['postfixadmin']['mysql']['instance']</code></td>
    <td>PostfixAdmin MySQL instance name to run by the mysql_service LWRP from the mysql cookbook</td>
    <td><code>'default'</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['mysql']['data_dir']</code></td>
    <td>PostfixAdmin MySQL data files path</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['mysql']['port']</code></td>
    <td>PostfixAdmin MySQL port</td>
    <td><code>'3306'</code></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['mysql']['run_group']</code></td>
    <td>PostfixAdmin MySQL system group</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['mysql']['run_user']</code></td>
    <td>PostfixAdmin MySQL system user</td>
    <td><em>calculated</em></td>
  </tr>
  <tr>
    <td><code>node['postfixadmin']['mysql']['version']</code></td>
    <td>PostfixAdmin database MySQL version to install</td>
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
    <td><code>node["boxbilling"]["mysql"]["server_root_password"]</code></td>
    <td>PostfixAdmin MySQL <em>root</em> password.</td>
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
  <tr>
    <td><code>node['postfixadmin']['php-fpm']['pool']</code></td>
    <td>PHP-FPM pool name to use with PostfixAdmin.</code></td>
    <td><code>'postfixadmin'</code></td>
  </tr>
</table>

## The HTTPS Certificate

This cookbook uses the [`ssl_certificate`](https://supermarket.getchef.com/cookbooks/ssl_certificate) cookbook to create the HTTPS certificate. The namespace used is `node['postfixadmin']`. For example:

```ruby
node.default['postfixadmin']['common_name'] = 'postfixadmin.example.com'
include_recipe 'postfixadmin'
```

See the [`ssl_certificate` namespace documentation](https://supermarket.getchef.com/cookbooks/ssl_certificate#namespaces) for more information.

## Encrypted Attributes

This cookbook can use the [encrypted_attributes](https://supermarket.getchef.com/cookbooks/encrypted_attributes) cookbook to encrypt the secrets generated during the *Chef Run*. This feature is disabled by default, but can be enabled setting the `node["postfixadmin"]["encrypt_attributes"]` attribute to `true`. For example:

```ruby
include_recipe 'encrypted_attributes::users_data_bag'
node.default['postfixadmin']['encrypt_attributes'] = true
inclure_recipe 'postfixadmin'
```

This will create the following encrypted attributes:

* `node['postfixadmin']['setup_password']`: PostfixAdmin *setup.php* setup password.
* `node['postfixadmin']['setup_password_encrypted']`: PostfixAdmin *setup.php* setup password encrypted with a salt.
* `node['postfixadmin']['mysql']['server_root_password']`: MySQL *root* user password.
* `node['postfixadmin']['database']['password']`: MySQL PostfixAdmin user password.

Read the [`chef-encrypted-attributes` gem documentation](http://onddo.github.io/chef-encrypted-attributes/) to learn how to read them.

**Warning:** When PostgreSQL is used, the database root password will still remain unencrypted in the `node['postgresql']['password']['postgres']` attribute due to limitations of the [postgresql cookbook](https://supermarket.getchef.com/cookbooks/postgresql).

Recipes
=======

## postfixadmin::default

Installs and configures PostfixAdmin.

## postfixadmin::map_files

Installs PostfixAdmin SQL map files to be used by Postfix.

## postfixadmin::mysql

Installs MySQL server for PostfixAdmin.

## postfixadmin::postgresql

Installs PostgreSQL server for PostfixAdmin.

Resources
=========

## postfixadmin_admin[user]

Create or remove a PostfixAdmin admin user. This kind of user is used to create the domains and mailboxes.

### postfixadmin_admin Actions

* `create`: Create a PostfixAdmin admin user (default).
* `remove`: Remove a PostfixAdmin admin user.

### postfixadmin_admin Parameters

<table>
  <tr>
    <th>Parameter</th>
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

### postfixadmin_admin Example

```ruby
postfixadmin_admin 'admin@admindomain.com' do
  password 'sup3r-s3cr3t-p4ss'
  action :create
end
```

## postfixadmin_domain[domain]

Create domains.

### postfixadmin_domain Actions

* `create`

### postfixadmin_domain Parameters

<table>
  <tr>
    <th>Parameter</th>
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

### postfixadmin_domain Example

```ruby
# admin user copied from the previous example
postfixadmin_domain 'foobar.com' do
  login_username 'admin@admindomain.com'
  login_password 'sup3r-s3cr3t-p4ss'
end
```

## postfixadmin_mailbox[mailbox]

Create a mailbox.

### postfixadmin_mailbox Actions

* `create`

### postfixadmin_mailbox Parameters

<table>
  <tr>
    <th>Parameter</th>
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

### postfixadmin_mailbox Example

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

### postfixadmin_alias Actions

* `create`

### postfixadmin_alias Parameters

<table>
  <tr>
    <th>Parameter</th>
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

### postfixadmin_alias Example

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

### postfixadmin_alias_domain Actions

* `create`

### postfixadmin_alias_domain Parameters

<table>
  <tr>
    <th>Parameter</th>
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

### postfixadmin_alias_domain Example

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
# [...]

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

PostgreSQL Support
==================

PostfixAdmin with PostgreSQL may not work properly on some platforms: See for example [`postgresql` cookbook issue #249](https://github.com/hw-cookbooks/postgresql/issues/249). [Any feedback you can provide regarding the PostgreSQL support](https://github.com/onddo/postfixadmin-cookbook/issues/new?title=PostgreSQL%20Support) will be greatly appreciated.

## PostgreSQL Support on Debian and Ubuntu

Due to [`postgresql` cookbook issue #108](https://github.com/hw-cookbooks/postgresql/issues/108), you should configure your system locale correctly for PostgreSQL to work. You can use the `locale` cookbook to fix this. For example:

```ruby
ENV['LANGUAGE'] = ENV['LANG'] = node['locale']['lang']
ENV['LC_ALL'] = node['locale']['lang']
include_recipe 'locale'
# ...
node.default['postfixadmin']['database']['type'] = 'postgresql'
include_recipe 'postfixadmin'
```

## PostgreSQL Versions < 9.3

If you are using PostgreSQL version `< 9.3`, you may need to adjust the `shmmax` and `shmall` kernel parameters to configure the shared memory. You can see [the example used for the integration tests](test/cookbooks/postfixadmin_test/recipes/_postgresql_memory.rb).

Testing
=======

See [TESTING.md](https://github.com/onddo/postfixadmin-cookbook/blob/master/TESTING.md).

## ChefSpec Matchers

### postfixadmin_admin(user)

Helper method for locating a `postfixadmin_admin` resource in the collection.

```ruby
resource = chef_run.postfixadmin_admin(user)
expect(resource).to notify('service[apache2]').to(:reload)
```

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

### postfixadmin_alias(address)

Helper method for locating a `postfixadmin_alias` resource in the collection.

```ruby
resource = chef_run.postfixadmin_alias(address)
expect(resource).to notify('service[apache2]').to(:reload)
```

### create_postfixadmin_alias(address)

Assert that the *Chef Run* creates a PostfixAdmin alias.

```ruby
expect(chef_run).to create_postfixadmin_alias(address)
```

### postfixadmin_alias_domain(alias_domain)

Helper method for locating a `postfixadmin_alias_domain` resource in the collection.

```ruby
resource = chef_run.postfixadmin_alias_domain(alias_domain)
expect(resource).to notify('service[apache2]').to(:reload)
```

### create_postfixadmin_alias_domain(alias_domain)

Assert that the *Chef Run* creates a PostfixAdmin alias domain.

```ruby
expect(chef_run).to create_postfixadmin_alias_domain(alias_domain)
```

### postfixadmin_domain(domain)

Helper method for locating a `postfixadmin_domain` resource in the collection.

```ruby
resource = chef_run.postfixadmin_domain(domain)
expect(resource).to notify('service[apache2]').to(:reload)
```

### create_postfixadmin_domain(domain)

Assert that the *Chef Run* creates a PostfixAdmin domain.

```ruby
expect(chef_run).to create_postfixadmin_domain(domain)
```

### postfixadmin_mailbox(mailbox)

Helper method for locating a `postfixadmin_mailbox` resource in the collection.

```ruby
resource = chef_run.postfixadmin_domain(mailbox)
expect(resource).to notify('service[apache2]').to(:reload)
```

### create_postfixadmin_mailbox(mailbox)

Assert that the *Chef Run* creates a PostfixAdmin mailbox.

```ruby
expect(chef_run).to create_postfixadmin_mailbox(mailbox)
```

Contributing
============

Please do not hesitate to [open an issue](https://github.com/onddo/postfixadmin-cookbook/issues/new) with any questions or problems.

See [CONTRIBUTING.md](https://github.com/onddo/postfixadmin-cookbook/blob/master/CONTRIBUTING.md).

TODO
====

See [TODO.md](https://github.com/onddo/postfixadmin-cookbook/blob/master/TODO.md).


License and Author
==================

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | [Xabier de Zuazo](https://github.com/zuazo) (<xabier@onddo.com>)
| **Contributor:**     | [chrludwig](https://github.com/chrludwig)
| **Contributor:**     | [MATSUI Shinsuke (poppen)](https://github.com/poppen)
| **Contributor:**     | [Brian Racer](https://github.com/anveo)
| **Contributor:**     | [Bernhard Weisshuhn (a.k.a. bernhorst)](https://github.com/bkw)
| **Copyright:**       | Copyright (c) 2013-2015 Onddo Labs, SL. (www.onddo.com)
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
