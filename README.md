# transmission Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/transmission.svg)](https://supermarket.chef.io/cookbooks/transmission)
[![CI State](https://github.com/sous-chefs/transmission/workflows/ci/badge.svg)](https://github.com/sous-chefs/transmission/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Provides custom resources to install, configure, and manage the
[Transmission BitTorrent Client](https://transmissionbt.com).

This cookbook no longer provides recipe or node attribute APIs. See
[migration.md](migration.md) for the breaking migration guide.

## Requirements

### Platforms

* AlmaLinux 8+
* Amazon Linux 2023+
* CentOS Stream 9+
* Debian 12+
* Fedora
* openSUSE Leap 15+
* Oracle Linux 8+
* Red Hat Enterprise Linux 8+
* Rocky Linux 8+
* Ubuntu 22.04+

See [LIMITATIONS.md](LIMITATIONS.md) for package availability and source build notes.

### Chef

* Chef Infra Client 15.3+

## Resources

* [transmission_install](documentation/transmission_install.md)
* [transmission_config](documentation/transmission_config.md)
* [transmission_service](documentation/transmission_service.md)
* [transmission_torrent_file](documentation/transmission_torrent_file.md)

## Usage

```ruby
transmission_install 'default'

transmission_config 'default' do
  rpc_password 'changeme'
end

transmission_service 'default' do
  action %i(create enable start)
end
```

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook
maintainers working together to maintain important cookbooks. If you would like to know more,
visit [sous-chefs.org](https://sous-chefs.org/) or join the Chef Community Slack in
[#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Contributors

This project exists thanks to all the people who
[contribute](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false).

### Backers

Thank you to all our backers.

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your
website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
