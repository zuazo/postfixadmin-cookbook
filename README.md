PostfixAdmin Cookbook
=====================
[![GitHub](http://img.shields.io/badge/github-zuazo/postfixadmin--cookbook-blue.svg?style=flat)](https://github.com/zuazo/postfixadmin-cookbook)
[![License](https://img.shields.io/github/license/zuazo/postfixadmin-cookbook.svg?style=flat)](#license-and-author)

[![Cookbook Version](https://img.shields.io/cookbook/v/postfixadmin.svg?style=flat)](https://supermarket.chef.io/cookbooks/postfixadmin)
[![Dependency Status](http://img.shields.io/gemnasium/zuazo/postfixadmin-cookbook.svg?style=flat)](https://gemnasium.com/zuazo/postfixadmin-cookbook)
[![Code Climate](http://img.shields.io/codeclimate/github/zuazo/postfixadmin-cookbook.svg?style=flat)](https://codeclimate.com/github/zuazo/postfixadmin-cookbook)
[![Build Status](http://img.shields.io/travis/zuazo/postfixadmin-cookbook/3.0.0.svg?style=flat)](https://travis-ci.org/zuazo/postfixadmin-cookbook)
[![Coverage Status](http://img.shields.io/coveralls/zuazo/postfixadmin-cookbook/3.0.0.svg?style=flat)](https://coveralls.io/r/zuazo/postfixadmin-cookbook?branch=3.0.0)

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
  - [PostgreSQL Versions < 9.3](#postgresql-versions--93)
- [Deploy with Docker](#deploy-with-docker)
- [Testing](#testing)
  - [ChefSpec Matchers](#chefspec-matchers)
- [Contributing](#contributing)
- [TODO](#todo)
- [License and Author](#license-and-author)

Requirements
============

Please, if you want to upgrade the `postfixadmin` cookbook version from the `1.x` branch, see the [CHANGELOG](https://github.com/zuazo/postfixadmin-cookbook/blob/master/CHANGELOG.md#v200-2015-05-09).

## Supported Platforms

This cookbook has been tested on the following platforms:

* Amazon Linux
* CentOS
* Debian
* Fedora
* Ubuntu

Please, [let us know](https://github.com/zuazo/postfixadmin-cookbook/issues/new?title=I%20have%20used%20it%20successfully%20on%20...) if you use it successfully on any other platform.

## Required Cookbooks

* [apache2](https://supermarket.chef.io/cookbooks/apache2)
* [ark](https://supermarket.chef.io/cookbooks/ark)
* [database](https://supermarket.chef.io/cookbooks/database)
* [encrypted_attributes](https://supermarket.chef.io/cookbooks/encrypted_attributes)
* [mysql](https://supermarket.chef.io/cookbooks/mysql)
* [chef_nginx](https://supermarket.chef.io/cookbooks/chef_nginx)
* [compat_resource](https://supermarket.chef.io/cookbooks/compat_resource)
* [openssl](https://supermarket.chef.io/cookbooks/openssl)
* [php](https://supermarket.chef.io/cookbooks/php)
* [php-fpm](https://supermarket.chef.io/cookbooks/php-fpm)
* [postgresql](https://supermarket.chef.io/cookbooks/postgresql)
* [ssl_certificate](https://supermarket.chef.io/cookbooks/ssl_certificate)
* [yum-epel](https://supermarket.chef.io/cookbooks/yum-epel)

## Required Applications

* Chef `12.5` or higher.
* Ruby `2.2` or higher.

Only Postfix Admin version `3` or higher is supported by this cookbook. For older versions, use cookbook versions `< 3`.

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

| Attribute                                             | Default                 | Description                    |
|:------------------------------------------------------|:------------------------|:-------------------------------|
| `node['postfixadmin']['version']`                     | `'3.0.2'`               | PostfixAdmin version
| `node['postfixadmin']['url']`                         | *calculated*            | PostfixAdmin download URL
| `node['postfixadmin']['checksum']`                    | *calculated*            | PostfixAdmin download file checksum
| `node['postfixadmin']['port']`                        | *calculated*            | PostfixAdmin listen port
| `node['postfixadmin']['server_name']`                 | *calculated*            | PostfixAdmin server name
| `node['postfixadmin']['server_aliases']`              | `[]`                    | PostfixAdmin server aliases
| `node['postfixadmin']['headers']`                     | `{}`                    | PostfixAdmin HTTP headers to set as hash
| `node['postfixadmin']['ssl']`                         | `false`                 | enables HTTPS (with SSL)
| `node['postfixadmin']['encrypt_attributes']`          | `false`                 | Whether to encrypt PostfixAdmin attributes containing credential secrets.
| `node['postfixadmin']['setup_password']`              | *calculated*            | PostfixAdmin Setup Password (required for chef-solo)
| `node['postfixadmin']['setup_password_salt']`         | *calculated*            | PostfixAdmin password salt (required for chef-solo)
| `node['postfixadmin']['web_server']`                  | `'apache'`              | Web server to use: `'apache'`, `'nginx'` or `false`
| `node['postfixadmin']['setup_password_encrypted']`    | *calculated*            | PostfixAdmin encrypted Password
| `node['postfixadmin']['database']['manage']`          | *calculated*            | Whether to manage database creation.
| `node['postfixadmin']['database']['type']`            | `'mysql'`               | PostfixAdmin database type. Possible values are: `'mysql'`, `'postgresql' (Please, see [below](#postgresql-support)<a></a>)`
| `node['postfixadmin']['database']['name']`            | `'postfix'`             | PostfixAdmin database name
| `node['postfixadmin']['database']['host']`            | `'127.0.0.1'`           | PostfixAdmin database hostname or IP address
| `node['postfixadmin']['database']['user']`            | `'postfix'`             | PostfixAdmin database login username
| `node['postfixadmin']['database']['password']`        | *calculated*            | PostfixAdmin database login password (requried for chef-solo)
| `node['postfixadmin']['mysql']['instance']`           | `'default'`             | PostfixAdmin MySQL instance name to run by the mysql_service LWRP from the mysql cookbook
| `node['postfixadmin']['mysql']['data_dir']`           | *calculated*            | PostfixAdmin MySQL data files path
| `node['postfixadmin']['mysql']['port']`               | `'3306'`                | PostfixAdmin MySQL port
| `node['postfixadmin']['mysql']['run_group']`          | *calculated*            | PostfixAdmin MySQL system group
| `node['postfixadmin']['mysql']['run_user']`           | *calculated*            | PostfixAdmin MySQL system user
| `node['postfixadmin']['mysql']['version']`            | *calculated*            | PostfixAdmin database MySQL version to install
| `node['postfixadmin']['conf']['encrypt']`             | `'md5crypt'`            | The way do you want the passwords to be crypted
| `node['postfixadmin']['conf']['domain_path']`         | `'YES'`                 | Whether you want to store the mailboxes per domain
| `node['postfixadmin']['conf']['domain_in_mailbox']`   | `'NO'`                  | Whether you want to have the domain in your mailbox
| `node['postfixadmin']['conf']['fetchmail']`           | `'NO'`                  | Whether you want fetchmail tab
| `node['postfixadmin']['packages']['requirements']`    | *calculated*            | PostfixAdmin required packages array
| `node['postfixadmin']['packages']['mysql']`           | *calculated*            | PostfixAdmin required packages array for MySQL support
| `node['postfixadmin']['packages']['postgresql']`      | *calculated*            | PostfixAdmin required packages array for PostgreSQL support
| `node['boxbilling']['mysql']['server_root_password']` | *calculated*            | PostfixAdmin MySQL *root* password.
| `node['postfixadmin']['map_files']['path']`           | `'/etc/postfix/tables'` | Path to generate map-files into
| `node['postfixadmin']['map_files']['mode']`           | `00640`                 | Map-files file-mode bits
| `node['postfixadmin']['map_files']['owner']`          | `'root'`                | Map-files files owner
| `node['postfixadmin']['map_files']['group']`          | `'postfix'`             | Map-files files group
| `node['postfixadmin']['map_files']['list']`           | *calculated*            | An array with map file names to generate
| `node['postfixadmin']['php-fpm']['pool']`             | `'postfixadmin'`        | PHP-FPM pool name to use with PostfixAdmin.

## The HTTPS Certificate

This cookbook uses the [`ssl_certificate`](https://supermarket.chef.io/cookbooks/ssl_certificate) cookbook to create the HTTPS certificate. The namespace used is `node['postfixadmin']`. For example:

```ruby
node.default['postfixadmin']['common_name'] = 'postfixadmin.example.com'
include_recipe 'postfixadmin'
```

See the [`ssl_certificate` namespace documentation](https://supermarket.chef.io/cookbooks/ssl_certificate#namespaces) for more information.

## Encrypted Attributes

This cookbook can use the [encrypted_attributes](https://supermarket.chef.io/cookbooks/encrypted_attributes) cookbook to encrypt the secrets generated during the *Chef Run*. This feature is disabled by default, but can be enabled setting the `node['postfixadmin']['encrypt_attributes']` attribute to `true`. For example:

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

**Warning:** When PostgreSQL is used, the database root password will still remain unencrypted in the `node['postgresql']['password']['postgres']` attribute due to limitations of the [postgresql cookbook](https://supermarket.chef.io/cookbooks/postgresql).

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

Create or delete a PostfixAdmin admin user.

This kind of user is used to create the domains and mailboxes, and must be used before any other resource from this cookbook.

### postfixadmin_admin Actions

* `create`: Create a PostfixAdmin admin user (default).
* `delete`: Remove a PostfixAdmin admin user.

### postfixadmin_admin Properties

| Property       | Default                       | Description                    |
|:---------------|:------------------------------|:-------------------------------|
| user           | *name attribute*              | Username
| password       | *required*                    | Password
| setup_password | *calculated*                  | PostfixAdmin Setup Password
| superadmin     | `true`                        | Whether it has access to all domains
| domains        | `[]`                          | List of domains it has access to
| active         | `true`                        | Active status
| login_username | *optional*                    | Admin user to use for its creation
| login_password | *optional*                    | Admin password to use for its creation
| ssl            | `node['postfixadmin']['ssl']` | Whether to use SSL on HTTP requests

If you don't provide `login_username`, it will use the *setup.php* to create the admin. Usually this is used only to create the first administrator.

### postfixadmin_admin Example

```ruby
postfixadmin_admin 'admin@admindomain.com' do
  password 'sup3r-s3cr3t-p4ss'
  action :create
end

postfixadmin_admin 'secondadmin@admindomain.com' do
  password '4n0th3r-p4ss'
  login_username 'admin@admindomain.com'
  login_password 'sup3r-s3cr3t-p4ss'
end
```

## postfixadmin_domain[domain]

Create or delete a domain.

### postfixadmin_domain Actions

* `create`
* `delete`

### postfixadmin_domain Properties

| Property        | Default                       | Description                    |
|:----------------|:------------------------------|:-------------------------------|
| domain          | *name attribute*              | Domain name
| description     | `''`                          | Domain description
| aliases         | `10`                          | Maximum number of aliases
| mailboxes       | `10`                          | Maximum number of mailboxes
| active          | `true`                        | Active status
| default_aliases | `false`                       | Whether to include default aliases
| login_username  | *required*                    | Admin user to use
| login_password  | *required*                    | Admin password
| ssl             | `node['postfixadmin']['ssl']` | Whether to use SSL on HTTP requests

### postfixadmin_domain Example

```ruby
# admin user copied from the previous example
postfixadmin_domain 'foobar.com' do
  login_username 'admin@admindomain.com'
  login_password 'sup3r-s3cr3t-p4ss'
end
```

## postfixadmin_mailbox[mailbox]

Create or delete a mailbox.

### postfixadmin_mailbox Actions

* `create`
* `delete`

### postfixadmin_mailbox Properties

| Property       | Default                       | Description                    |
|:---------------|:------------------------------|:-------------------------------|
| mailbox        | *name attribute*              | Mailbox address to create
| password       | *required*                    | Mailbox password
| name           | `''`                          | The name of the mailbox owner
| active         | `true`                        | Active status
| mail           | `false`                       | Whether to send a welcome email
| login_username | *required*                    | Admin user to use
| login_password | *required*                    | Admin password
| ssl            | `node['postfixadmin']['ssl']` | Whether to use SSL on HTTP requests

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

Create or delete a mailbox alias.

### postfixadmin_alias Actions

* `create`
* `delete`

### postfixadmin_alias Properties

| Property       | Default                       | Description                    |
|:---------------|:------------------------------|:-------------------------------|
| address        | *name attribute*              | Alias address
| goto           | *required*                    | Destination mailbox address
| active         | `true`                        | Active status
| login_username | *required*                    | Admin user to use
| login_password | *required*                    | Admin password
| ssl            | `node['postfixadmin']['ssl']` | Whether to use SSL on HTTP requests

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

Create or remote a domain alias.

The domain name used as `alias_domain` must already exist: in other words, it needs to be created previously with `postfixadmin_domain` resource.

### postfixadmin_alias_domain Actions

* `create`
* `delete`

### postfixadmin_alias_domain Properties

| Property       | Default                       | Description                    |
|:---------------|:------------------------------|:-------------------------------|
| alias_domain   | *name attribute*              | Alias domain
| target_domain  | *required*                    | Target domain
| active         | `true`                        | Active status
| login_username | *required*                    | Admin user to use
| login_password | *required*                    | Admin password
| ssl            | `node['postfixadmin']['ssl']` | Whether to use SSL on HTTP requests

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

postfixadmin_domain 'aliasdomain.com' do
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
  "name": "mail.example.com",
  "[...]": "[...]"
  "run_list": [
    "[...]": "[...]",
    "recipe[postfixadmin]",
    "recipe[postfixadmin::map_files]"
  ]
}
```

PostgreSQL Support
==================

PostfixAdmin with PostgreSQL may not work properly on some platforms: See for example [`postgresql` cookbook issue #249](https://github.com/hw-cookbooks/postgresql/issues/249). [Any feedback you can provide regarding the PostgreSQL support](https://github.com/zuazo/postfixadmin-cookbook/issues/new?title=PostgreSQL%20Support) will be greatly appreciated.

## PostgreSQL Versions < 9.3

If you are using PostgreSQL version `< 9.3`, you may need to adjust the `shmmax` and `shmall` kernel parameters to configure the shared memory. You can see [the example used for the integration tests](https://github.com/zuazo/postfixadmin-cookbook/tree/master/test/cookbooks/postfixadmin_test/recipes/_postgresql_memory.rb).

Deploy with Docker
==================

You can use the *Dockerfile* included in the [cookbook source code](https://github.com/zuazo/postfixadmin-cookbook) to run the cookbook inside a container:

    $ docker build -t chef-postfixadmin .
    $ docker run -d -p 8080:80 chef-postfixadmin

The sample *Dockerfile*:

```Dockerfile
FROM zuazo/chef-local:debian-7

COPY . /tmp/postfixadmin
RUN berks vendor -b /tmp/postfixadmin/Berksfile $COOKBOOK_PATH
RUN chef-client -r "recipe[apt],recipe[postfixadmin]"

CMD ["apache2", "-D", "FOREGROUND"]
```

See the [chef-local container documentation](https://registry.hub.docker.com/u/zuazo/chef-local/) for more examples.

Testing
=======

See [TESTING.md](https://github.com/zuazo/postfixadmin-cookbook/blob/master/TESTING.md).

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

### delete_postfixadmin_admin(path)

Assert that the *Chef Run* deletes a PostfixAdmin admin user.

```ruby
expect(chef_run).to delete_postfixadmin_admin(user)
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

### delete_postfixadmin_alias(address)

Assert that the *Chef Run* deletes a PostfixAdmin alias.

```ruby
expect(chef_run).to delete_postfixadmin_alias(address)
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

### delete_postfixadmin_alias_domain(alias_domain)

Assert that the *Chef Run* deletes a PostfixAdmin alias domain.

```ruby
expect(chef_run).to delete_postfixadmin_alias_domain(alias_domain)
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

### delete_postfixadmin_domain(domain)

Assert that the *Chef Run* deletes a PostfixAdmin domain.

```ruby
expect(chef_run).to delete_postfixadmin_domain(domain)
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

### delete_postfixadmin_mailbox(domain)

Assert that the *Chef Run* deletes a PostfixAdmin mailbox.

```ruby
expect(chef_run).to delete_postfixadmin_mailbox(mailbox)
```

Contributing
============

Please do not hesitate to [open an issue](https://github.com/zuazo/postfixadmin-cookbook/issues/new) with any questions or problems.

See [CONTRIBUTING.md](https://github.com/zuazo/postfixadmin-cookbook/blob/master/CONTRIBUTING.md).

TODO
====

See [TODO.md](https://github.com/zuazo/postfixadmin-cookbook/blob/master/TODO.md).


License and Author
==================

|                      |                                          |
|:---------------------|:-----------------------------------------|
| **Author:**          | [Xabier de Zuazo](https://github.com/zuazo) (<xabier@zuazo.org>)
| **Contributor:**     | [chrludwig](https://github.com/chrludwig)
| **Contributor:**     | [MATSUI Shinsuke (poppen)](https://github.com/poppen)
| **Contributor:**     | [Brian Racer](https://github.com/anveo)
| **Contributor:**     | [Bernhard Weisshuhn (a.k.a. bernhorst)](https://github.com/bkw)
| **Copyright:**       | Copyright (c) 2015, Xabier de Zuazo
| **Copyright:**       | Copyright (c) 2014-2015, Onddo Labs, SL.
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
