# transmission_service

Manages the Transmission daemon service.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Creates package override or source systemd unit. |
| `:enable` | Enables the service. |
| `:start` | Starts the service. |
| `:restart` | Restarts the service. |
| `:reload` | Reloads the service. |
| `:stop` | Stops the service. |
| `:disable` | Disables the service. |
| `:delete` | Stops, disables, and removes managed service files. |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `install_method` | String | Platform dependent | `package` or `source`. |
| `binary_path` | String | Platform dependent | Path to `transmission-daemon`. |
| `user` | String | Platform dependent | Service user. |
| `group` | String | Platform dependent | Service group. |
| `home` | String | Platform dependent | Service home directory. |
| `config_dir` | String | Platform dependent | Transmission configuration directory. |
| `defaults_path` | String | Platform dependent | Service defaults file path. |

## Examples

```ruby
transmission_service 'default' do
  action %i(create enable start)
end
```
