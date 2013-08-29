name             "transmission"
maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs/Configures transmission"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "2.0.1"

%w{ openssl build-essential }.each do |cb|
  depends cb
end
