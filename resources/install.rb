property :install_method, String, equal_to: %w(package source)
use 'partial/_source'

property, :incomplete_dir_enabled,
          [true, false],
          default: false

property, :peer_port,
          Integer,
          default: 51_413

property, :ratio_limit,
          String,
          default: '2.0000',

property, :ratio_limit_enabled,
          String,
          default: ''

property, :rpc_bind_address,
          String,
          default: '0.0.0.0'

property, :rpc_password,
          String,
          default: ''

property, :rpc_port,
          Integer,
          default: 9091

property, :rpc_username,
          String,
          default: 'transmission'

property, :rpc_whitelist,
          String,
          default: '127.0.0.1'

property, :rpc_whitelist_enabled,
          [true, false],
          default: true

property, :speed_limit_down,
          Integer,
          default: 100

property, :speed_limit_down_enabled,
          [true, false],
          default: false

property, :speed_limit_up,
          Integer,
          default: 100

property, :speed_limit_up_enabled,
          [true, false],
          default: false

property, :watch_dir_enabled,
          String,
          default: ''


unified_mode true

action :install do
  if new_resource.install_method == 'package'
    include_recipe 'yum-epel' if platform_family?('rhel', 'amazon')

    package %w(transmission transmission-cli transmission-daemon)
  else
    transmission_source_install do
      version new_resoruce.version
      url new_resoruce.url
      checksum new_resoruce.checksum
      user new_resoruce.user
      group new_resoruce.group
    end
  end

  template transmission_defaults do
    source 'transmission-daemon.default.erb'
    variables(config_dir: transmission_config_dir)
    notifies :reload, 'service[transmission]'
  end

  if new_resoruce.install_method == 'package'
    directory '/etc/systemd/system/transmission-daemon.service.d'

    template '/etc/systemd/system/transmission-daemon.service.d/10-override.conf' do
      variables(defaults: transmission_defaults)
      notifies :run, 'execute[systemctl daemon-reload]', :immediately
      notifies :reload, 'service[transmission]'
    end

    execute 'systemctl daemon-reload' do
      action :nothing
    end
  end

  directory '/etc/transmission-daemon' do
    owner 'root'
    group new_resoruce.group
    mode '0755'
  end

  directory "#{transmission_config_dir}/info" do
    recursive true
  end

  template "#{transmission_config_dir}/settings.json" do
    source 'settings.json.erb'
    owner new_resoruce.user
    group new_resoruce.group
    manage_symlink_source true
    variables(
      download_dir: transmission_download_dir,
      incomplete_dir: transmission_incomplete_dir,
      watch_dir: transmission_watch_dir,
      incomplete_dir_enabled: new_resoruce.incomplete_dir_enabled.to_s,
      peer_port: new_resoruce.peer_port,
      ratio_limit: new_resoruce.ratio_limit,
      ratio_limit_enabled: new_resoruce.ratio_limit_enabled,
      rpc_bind_address: new_resoruce.rpc_bind_address,
      rpc_password: new_resoruce.rpc_password,
      rpc_port: new_resoruce.rpc_port,
      rpc_username: new_resoruce.rpc_username,
      rpc_whitelist: new_resoruce.rpc_whitelist,
      rpc_whitelist_enabled: new_resoruce.rpc_whitelist_enabled,
      speed_limit_down: new_resoruce.speed_limit_down,
      speed_limit_down_enabled: new_resoruce.speed_limit_down_enabled.to_s,
      speed_limit_up: new_resoruce.speed_limit_up,
      speed_limit_up_enabled: new_resoruce.speed_limit_up_enabled.to_s,
      watch_dir_enabled: new_resoruce.watch_dir_enabled
    )
    notifies :reload, 'service[transmission]', :immediately
  end

  link '/etc/transmission-daemon/settings.json' do
    to "#{transmission_config_dir}/settings.json"
    not_if { File.symlink?("#{transmission_config_dir}/settings.json") }
  end

  service 'transmission' do
    service_name 'transmission-daemon'
    supports restart: true, reload: true
    action [:enable, :start]
  end
end
