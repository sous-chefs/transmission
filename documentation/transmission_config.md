# transmission_config

Creates Transmission directories, defaults, and `settings.json`.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Creates configuration. Default. |
| `:delete` | Removes configuration files and managed directories. |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `rpc_password` | String | Required | RPC password. Sensitive. |
| `rpc_username` | String | `transmission` | RPC username. |
| `rpc_port` | Integer | `9091` | RPC port. |
| `rpc_bind_address` | String | `0.0.0.0` | RPC bind address. |
| `rpc_whitelist` | String | `127.0.0.1` | RPC whitelist. |
| `rpc_whitelist_enabled` | Boolean | `true` | Enables RPC whitelist enforcement. |
| `peer_port` | Integer | `51413` | Peer listening port. |
| `download_dir` | String | Platform dependent | Completed download directory. |
| `incomplete_dir` | String | Platform dependent | Incomplete download directory. |
| `watch_dir` | String | Platform dependent | Watch directory. |
| `incomplete_dir_enabled` | Boolean | `false` | Enables incomplete directory use. |
| `watch_dir_enabled` | Boolean | `false` | Enables watch directory use. |
| `ratio_limit` | Float, String | `2.0000` | Seed ratio limit. |
| `ratio_limit_enabled` | Boolean | `false` | Enables seed ratio limit. |
| `speed_limit_down` | Integer | `100` | Download speed limit in KB/s. |
| `speed_limit_down_enabled` | Boolean | `false` | Enables download speed limit. |
| `speed_limit_up` | Integer | `100` | Upload speed limit in KB/s. |
| `speed_limit_up_enabled` | Boolean | `false` | Enables upload speed limit. |

## Examples

```ruby
transmission_config 'default' do
  rpc_password 'changeme'
  rpc_bind_address '0.0.0.0'
end
```
