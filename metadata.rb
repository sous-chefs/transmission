name 'transmission'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache-2.0'
description 'Installs and configures transmission'
version '4.0.1'

%w(ubuntu debian redhat centos suse scientific oracle amazon fedora opensuse opensuseleap).each do |os|
  supports os
end

%w( openssl build-essential ).each do |cb|
  depends cb
end

source_url 'https://github.com/chef-cookbooks/transmission'
issues_url 'https://github.com/chef-cookbooks/transmission/issues'

chef_version '>= 12.14'

gem 'bencode'
gem 'i18n'
gem 'transmission-simple'
gem 'activesupport'
