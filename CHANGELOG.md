# transmission Cookbook CHANGELOG

This file is used to list changes made in each version of the transmission cookbook.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 6.0.2 - *2023-04-04*

* Standardise files with files in sous-chefs/repo-management

## 6.0.1 - *2022-02-10*

* resolved cookstyle error: tasks/maintainers.rb:37:7 convention: `Style/FileWrite`
* resolved cookstyle error: metadata.rb:23:1 refactor: `Chef/Modernize/DependsOnOpensslCookbook`
* resolved cookstyle error:
  * Chef/Deprecations/Delivery: Do not include a .delivery directory for the delivery command in your cookbooks. Chef Delivery (Workflow) went EOL Dec 31st 2021 and the delivery command was removed from Chef Workstation Feb 2022. (<https://docs.chef.io/workstation/cookstyle/chef_deprecations_delivery>)
* resolved cookstyle error:
  * Chef/Correctness/OpenSSLPasswordHelpers: The secure_password helper from the openssl cookbooks Opscode::OpenSSL::Password class should not be used to generate passwords. (<https://docs.chef.io/workstation/cookstyle/chef_correctness_opensslpasswordhelpers>) ::Chef::Node.include Opscode::OpenSSL::Password
* Update provisioner settings
* Update tested platforms

## 6.0.0 - *2021-08-20*

* Set unified_mode on resources for Chef 17 support
* Require Chef 15.3+ for unified_mode support

## 5.0.3 - *2021-08-14*

* Standardising files in line with updated recommendations

## 5.0.2 - *2021-06-01*

* Standardise files with files in sous-chefs/repo-management

## 5.0.1 - *2021-03-25*

* resolved cookstyle error: providers/torrent_file.rb:120:21 convention: `Style/RedundantBegin`
* resolved cookstyle error: providers/torrent_file.rb:121:1 convention: `Layout/EmptyLinesAroundMethodBody`
* resolved cookstyle error: providers/torrent_file.rb:121:1 convention: `Layout/TrailingWhitespace`

## 5.0.0 (2020-11-13)

* Sous Chefs Adoption
* Update Changelog to Sous Chefs
* Update to use Sous Chefs GH workflow
* Update README to sous-chefs
* Update metadata.rb to Sous Chefs
* Update test-kitchen to Sous Chefs
* Update to version 3.00 for source installation
* Added InSpec test profile
* resolved cookstyle error: providers/torrent_file.rb:76:60 convention: `Style/RedundantParentheses`
* resolved cookstyle error: attributes/default.rb:20:14 warning: `Lint/SendWithMixinArgument`
* resolved cookstyle error: metadata.rb:12:1 refactor: `ChefStyle/OverlyComplexSupportsDependsMetadata`
* resolved cookstyle error: metadata.rb:13:1 refactor: `ChefModernize/UnnecessaryDependsChef14`
* Cookstyle fixes
* Yamllint fixes
* MDL fixes
* Fix CentOS/Fedora installation
* Source installation issues
* Fix SUSE source installation
* Remove Amazon Linux 1 testing
* Remove EL 6 testing
* Remove init.d scripts
* Remove Oracle Linux testing

## 4.0.1 (2017-08-18)

* Add attributes for controling seed ratio

## 4.0.0 (2017-01-18)

* Use multipackage to speed up package installs
* Expand platform testing and fix 16.04 package tests
* Make sure we have ssl libs on debian systems
* Remove the chef 11 compatibility check in chef_gem
* Switch back to stable ChefDK builds for testing
* Require Chef 12.14 to get ruby 2.2.2+ which is needed for the gems that are installed by this cookbook

## 3.0.0 (2016-09-08)

* Add matchers
* Require Chef 12.1+

## 2.2.1 (2016-09-01)

* Add chef_version
* Testing updates
* Pull transmission from Github and use 2.92

## 2.2.0 (2016-08-11)

* Fix up chef_gem compile time warnings.
* Add support for transmission whitelist settings.
* Add use_inline_resources
* Add conditional to support older versions of chef.
* Update testing
* Specif version 4.x of activesupport to fix installs on Ruby 2.1 Chef omnibus

## v2.1.1 (2016-01-08)

* Add supports metadata for all supported platforms

## v2.1.0 (2016-01-08)

* Fixed installation via source on RHEL systems by adding openssl / tar packages to the source recipe
* Switched to platform_family to better support derivitive operating systems
* Updated to the latest version of Transmission for source installs
* Switched from .bz2 to .xz format archives for source installs as .bz2 archives are no longer being published. Xz tools will now be installed in the source recipe
* Added source test suite in Test Kitchen
* Removed support for RHEL releases before 7 as the version of libevent shipped in these distros is too old to compile tranmission

## v2.0.10 (2015-12-14)

* Set the minimum supported Chef release to 11
* Removed the monkeypatch to Ruby 1.8.6 support
* Resolved all rubocop warnings
* Added testing with Travis CI
* Added chefignore file
* Swaped Digital Ocean Test Kitchen config for Docker
* Added standard Chef .rubocop.yml
* Updated contributing and testing docs
* Added Gemfile with development deps
* Added maintainers file
* Added a Rakefile for simplified testing

## v2.0.9 (2015-02-18)

* reverting OpenSSL module namespace change

## v2.0.8 (2015-02-18)

* reverting chef_gem compile_time work

## v2.0.7 (2015-02-18)

* Updating to use the latest openssl

## v2.0.6 (2015-02-18)

* Fixing chef_gem for Chef below 12.1.0

## v2.0.4 (2014-09-18)

* [#11] prevent circular symlink for settings.json on Ubuntu 14.04
* Add Berksfile and test-kitchen config

## v2.0.2 (2014-03-19)

* [COOK-4424] Updates Transmission url in README'

## v2.0.0

**Requires Ruby 1.9 or higher!**

* Use Hash#key to silence Hash#index deprecation warnings
* Delete torrent local data when not seeding
* Prevent torrent status of checking from prematurely ending blocking downloads
* Use `BEncode.load_file` to load torrent file when hashing to avoid UTF-8 encoding issues
* Add watch dir options

## v1.0.4

* [COOK-2981]: transmission cookbook has foodcritic errors

## v1.0.2

* [COOK-729]: `transmission_torrent_file` doesn't work for more than a single torrent
* [COOK-732]: link to file in swarm not created if torrent already completely downloaded
