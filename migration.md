# Migration Guide

This release removes the legacy recipe and node attribute API. Consumers must declare resources
directly instead of adding `transmission::default`, `transmission::package`, or
`transmission::source` to a run list.

## Before

```ruby
run_list 'recipe[transmission::default]'

default['transmission']['rpc_password'] = 'changeme'
default['transmission']['rpc_port'] = 9091
```

## After

```ruby
transmission_install 'default'

transmission_config 'default' do
  rpc_password 'changeme'
  rpc_port 9091
end

transmission_service 'default' do
  action %i(create enable start)
end
```

## Attribute Mapping

| Removed attribute | Resource property |
|-------------------|-------------------|
| `node['transmission']['install_method']` | `transmission_install.install_method`, `transmission_service.install_method` |
| `node['transmission']['user']` | `user` |
| `node['transmission']['group']` | `group` |
| `node['transmission']['url']` | `transmission_install.source_url` |
| `node['transmission']['version']` | `transmission_install.version` |
| `node['transmission']['checksum']` | `transmission_install.checksum` |
| `node['transmission']['peer_port']` | `transmission_config.peer_port` |
| `node['transmission']['rpc_bind_address']` | `transmission_config.rpc_bind_address` |
| `node['transmission']['rpc_username']` | `transmission_config.rpc_username` |
| `node['transmission']['rpc_password']` | `transmission_config.rpc_password` |
| `node['transmission']['rpc_port']` | `transmission_config.rpc_port` |
| `node['transmission']['rpc_whitelist_enabled']` | `transmission_config.rpc_whitelist_enabled` |
| `node['transmission']['rpc_whitelist']` | `transmission_config.rpc_whitelist` |
| `node['transmission']['incomplete_dir_enabled']` | `transmission_config.incomplete_dir_enabled` |
| `node['transmission']['watch_dir_enabled']` | `transmission_config.watch_dir_enabled` |
| `node['transmission']['ratio_limit']` | `transmission_config.ratio_limit` |
| `node['transmission']['ratio_limit_enabled']` | `transmission_config.ratio_limit_enabled` |
| `node['transmission']['speed_limit_down']` | `transmission_config.speed_limit_down` |
| `node['transmission']['speed_limit_down_enabled']` | `transmission_config.speed_limit_down_enabled` |
| `node['transmission']['speed_limit_up']` | `transmission_config.speed_limit_up` |
| `node['transmission']['speed_limit_up_enabled']` | `transmission_config.speed_limit_up_enabled` |

The test cookbook under `test/cookbooks/test/recipes/default.rb` shows the primary workflow used
by Kitchen.
