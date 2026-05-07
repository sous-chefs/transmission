# transmission_install

Installs Transmission from operating system packages or from an upstream source tarball.

## Actions

| Action | Description |
| --- | --- |
| `:install` | Installs Transmission. Default. |
| `:remove` | Removes installed packages or the source-installed daemon binary. |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `install_method` | String | Platform dependent | `package` or `source`. |
| `package_names` | Array | `transmission`, `transmission-cli`, `transmission-daemon` | Packages to install. |
| `source_url` | String | Upstream release URL | Base URL for source archives. |
| `version` | String | `4.1.1` | Source version to build. |
| `checksum` | String | `nil` | Optional archive checksum. |
| `build_packages` | Array | Platform dependent | Packages required for source builds. |
| `source_prefix` | String | `/usr/local` | Source install prefix. |
| `user` | String | Platform dependent | Service user for source installs. |
| `group` | String | Platform dependent | Service group for source installs. |
| `home` | String | Platform dependent | Service home directory. |
| `config_dir` | String | Platform dependent | Transmission configuration directory. |
| `defaults_path` | String | Platform dependent | Service defaults file path. |

## Examples

```ruby
transmission_install 'default'

transmission_install 'source' do
  install_method 'source'
  version '4.1.1'
end
```
