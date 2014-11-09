Testing
=======

## Required Gems

* `vagrant`
* `foodcritic`
* `rubocop`
* `berkshelf`
* `should_not`
* `chefspec`
* `test-kitchen`
* `kitchen-vagrant`

### Required Gems for Guard

* `guard`
* `guard-foodcritic`
* `guard-rubocop`
* `guard-rspec`
* `guard-kitchen`

More info at [Guard Readme](https://github.com/guard/guard#readme).

## Installing the Requirements

You must have [VirtualBox](https://www.virtualbox.org/) and [Vagrant](http://www.vagrantup.com/) installed.

You can install gem dependencies with bundler:

    $ gem install bundler
    $ bundle install

## Running the Syntax Style Tests

    $ bundle exec rake style

## Running the Unit Tests

    $ bundle exec rake unit

## Running the Integration Tests

    $ bundle exec rake integration

Or:

    $ bundle exec kitchen list
    $ bundle exec kitchen test
    [...]

### Running Integration Tests in the Cloud

#### Requirements

* `kitchen-vagrant`
* `kitchen-digitalocean`
* `kitchen-ec2`

You can run the tests in the cloud instead of using vagrant. First, you must set the following environment variables:

* `AWS_ACCESS_KEY_ID`
* `AWS_SECRET_ACCESS_KEY`
* `AWS_KEYPAIR_NAME`: EC2 SSH public key name. This is the name used in Amazon EC2 Console's Key Pars section.
* `EC2_SSH_KEY_PATH`: EC2 SSH private key local full path. Only when you are not using an SSH Agent.
* `DIGITALOCEAN_ACCESS_TOKEN`
* `DIGITALOCEAN_SSH_KEY_IDS`: DigitalOcean SSH numeric key IDs.
* `DIGITALOCEAN_SSH_KEY_PATH`: DigitalOcean SSH private key local full path. Only when you are not using an SSH Agent.

Then, you must configure test-kitchen to use `.kitchen.cloud.yml` configuration file:

    $ export KITCHEN_LOCAL_YAML=".kitchen.cloud.yml"
    $ bundle exec kitchen list
    [...]

## Using Vagrant with the Vagrantfile

### Vagrantfile Requirements

* ChefDK: https://downloads.getchef.com/chef-dk/
* Berkhelf and Omnibus vagrant plugins:
```
$ vagrant plugin install vagrant-berkshelf vagrant-omnibus
```
* The path correctly set for ChefDK:
```
$ export PATH="/opt/chefdk/bin:${PATH}"
```
### Vagrantfile Usage

    $ vagrant up

To run Chef again on the same machine:

    $ vagrant provision

To destroy the machine:

    $ vagrant destroy

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
