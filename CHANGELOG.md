# CHANGELOG for postfixadmin

This file is used to list changes made in each version of `postfixadmin`.

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

