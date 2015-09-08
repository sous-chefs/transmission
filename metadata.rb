name 'transmission'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache 2.0'
description 'Installs/Configures transmission'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '2.0.9'

%w( openssl build-essential ).each do |cb|
  depends cb
end

source_url 'https://github.com/chef-cookbooks/transmission' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/transmission/issues' if respond_to?(:issues_url)
