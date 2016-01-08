name 'transmission'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache 2.0'
description 'Installs and configures transmission'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.1.1'

%w(ubuntu debian redhat centos suse scientific oracle amazon fedora).each do |os|
  supports os
end

%w( openssl build-essential ).each do |cb|
  depends cb
end

source_url 'https://github.com/chef-cookbooks/transmission' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/transmission/issues' if respond_to?(:issues_url)
