# transmission_torrent_file

Downloads a file through a running Transmission RPC service.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Adds the torrent and creates the target file. Default. |
| `:delete` | Deletes the target file. |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `path` | String | Name property | Target file path. |
| `torrent` | String | Required | Torrent URL or local torrent file path. |
| `blocking` | Boolean | `true` | Waits for download completion in the same Chef run. |
| `continue_seeding` | Boolean | `false` | Leaves torrent data in place and links to it. |
| `owner` | String | `nil` | Target owner. |
| `group` | String | `nil` | Target group. |
| `rpc_host` | String | `localhost` | Transmission RPC host. |
| `rpc_port` | Integer | `9091` | Transmission RPC port. |
| `rpc_username` | String | `transmission` | Transmission RPC username. |
| `rpc_password` | String | `nil` | Transmission RPC password. Sensitive. |

## Examples

```ruby
transmission_torrent_file '/srv/isos/ubuntu.iso' do
  torrent 'https://releases.ubuntu.com/24.04/ubuntu-24.04.3-live-server-amd64.iso.torrent'
  owner 'root'
  group 'root'
  rpc_password 'changeme'
end
```
