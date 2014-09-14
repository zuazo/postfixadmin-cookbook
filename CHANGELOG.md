# CHANGELOG for postfixadmin

This file is used to list changes made in each version of `postfixadmin`.

## 1.0.1

* Do not include `mysql::server` recipe.
* Added MySQL attributes documentation.
* PostgreSQL password generation moved to `recipe::postgresql`.
* `README`: generated password documentation fixed.
* Added Fedora and Amazon Linux support.

## 1.0.0

* Fixed Apache `2.4` support.
* FC001: Use strings in preference to symbols to access node attributes.
* FC023: Prefer conditional attributes.
* `kitchen.yml`: updated, some syntax improvements, added apt to the run list.
* `kitchen.yml`: added hostname and forwarded ports.
* Added `.kitchen.cloud.yml` file.
* *test/kitchen/cookbooks* directory moved to *test/cookbooks*.
* `Gemfile` updated and improved.
* Added a `TODO` file.
* Integrated with `ssl_certificate` cookbook and some related improvements:
 * **Update Warning**: This update will cause the self-signed certificate to be regenerated.
 * Added `server_aliases` attribute.
 * Added `headers` attribute.
 * Fixed SSL support in CentOS.
 * Both 80 and 443 ports remain enabled with SSL.
 * **Update Warning**: Log files path changed from *postfix_access.log* and *postfix_ssl_access.log* to *postfix-access.log* and *postfix-ssl-access.log* (the same applies applies to error logs).
 * Replaced `return`s in providers by `next`s.
 * Fixed apache restart for LWRPs.
* `web_app-postfixadmin-reload` resource for LWRPs after VirtualHost creation.
* All RuboCop offenses fixed, `Rakefile` added.
 * Library methods changed from `camelCase` to `snake_case`.
 * `exists?` library methods renamed to `exist?`.
 * Replaced `Chef::Application.fatal` by exceptions: avoids daemon exit.
 * Fixed map-files integration tests.
* `PostfixAdmin::MySQL` refactored: removed code duplication and logger configured.
* `PostfixAdmin::PHP` code duplication removed.
* Added PostgreSQL support (based on [@anveo's work](https://github.com/anveo/postfixadmin-cookbook/commits/postgresql-support), thanks!), including:
 * `PostfixAdmin::MySQL` library renamed to `PostfixAdmin::DB`.
 * PostfixAdmin HTML error parsing improved.
 * Required packages installation refactored using attributes.
 * Fixed `config.local.php` group value without apache.
* All integration tests fixed to pass.
* Added listening port attribute:
 * **Update Warning**: Only one port will be enabled by default at the same time (no more non-SSL + SSL combo).
* Added ChefSpec matchers.
* Added ChefSpec tests.
* Added `travis.yml` and multiple badges.
* `README`: updated a paragraph about database support.
* `README`: separated into multiple files and some titles fixed.
* `recipes::apache`: fixed disabling `web_app[postfixadmin-ssl]`.
* Integrated with `encrypted_attributes` cookbook:
 * FC007: Ensure recipe dependencies are reflected in cookbook metadata.
 * attributes: disable `encrypt_attributes` by default.
* Create MySQL database only for localhost.

## 0.2.0:

* Default PostfixAdmin version updated to `2.3.7`.
* `server_name` attribute *calculated*.
* `README`: Added requirements links.
* `README`: Added Cookbook Badge.
* `README`: some `alias_domain` titles fixed.
* Added `postfixadmin_alias_domain` LWRP.
* Added `serverspec` tests (issue [#4](https://github.com/onddo/postfixadmin-cookbook/pull/4), thanks [MATSUI Shinsuke (poppen)](https://github.com/poppen)).
* Separate recipe for apache (issue [#4](https://github.com/onddo/postfixadmin-cookbook/pull/4), thanks [MATSUI Shinsuke (poppen)](https://github.com/poppen)).
* `Gemfile`: switch to using the new version of vagrant (issue [#4](https://github.com/onddo/postfixadmin-cookbook/pull/4), thanks [MATSUI Shinsuke (poppen)](https://github.com/poppen)).
* `kitchen.yml`: updated to latest format.

## 0.1.3:

* Avoid nil package resource name for pkg_php_mbstring (issues [#2](https://github.com/onddo/postfixadmin-cookbook/pull/2) and [#3](https://github.com/onddo/postfixadmin-cookbook/pull/3), thanks [chrludwig](https://github.com/chrludwig)).

## 0.1.2:

* Fixed compatibility issues with Chef 11.8 (issue [#1](https://github.com/onddo/postfixadmin-cookbook/pull/1), thanks [mikelococo](https://github.com/mikelococo) for reporting).
* LWRPs fixed to notify only when an action is executed.

## 0.1.1:

* metadata: provides without square brackets to avoid [CHEF-3976](https://tickets.opscode.com/browse/CHEF-3976)

## 0.1.0:

* Initial release of `postfixadmin`

