# frozen_string_literal: true

provides :transmission_config
unified_mode true

use '_partial/_paths'
include Transmission::Cookbook::Helpers

property :download_dir, String, default: lazy { transmission_download_path }
property :incomplete_dir, String, default: lazy { transmission_incomplete_path }
property :watch_dir, String, default: lazy { transmission_watch_path }
property :peer_port, Integer, default: 51_413
property :rpc_bind_address, String, default: '0.0.0.0'
property :rpc_username, String, default: 'transmission'
property :rpc_password, String, required: true, sensitive: true
property :rpc_port, Integer, default: 9091
property :rpc_whitelist_enabled, [true, false], default: true
property :rpc_whitelist, String, default: '127.0.0.1'
property :incomplete_dir_enabled, [true, false], default: false
property :watch_dir_enabled, [true, false], default: false
property :ratio_limit, [Float, String], default: '2.0000'
property :ratio_limit_enabled, [true, false], default: false
property :speed_limit_down, Integer, default: 100
property :speed_limit_down_enabled, [true, false], default: false
property :speed_limit_up, Integer, default: 100
property :speed_limit_up_enabled, [true, false], default: false

default_action :create

action_class do
  include Transmission::Cookbook::Helpers
end

action :create do
  service 'transmission-daemon' do
    supports restart: true, reload: true
    action :nothing
  end

  directory ::File.dirname(new_resource.defaults_path) do
    owner 'root'
    group 'root'
    mode '0755'
    recursive true
  end

  template new_resource.defaults_path do
    source 'transmission-daemon.default.erb'
    cookbook 'transmission'
    variables(config_dir: new_resource.config_dir)
    notifies :reload, 'service[transmission-daemon]', :delayed
  end

  directory '/etc/transmission-daemon' do
    owner 'root'
    group new_resource.group
    mode '0755'
  end

  [new_resource.home, new_resource.config_dir, new_resource.download_dir, new_resource.incomplete_dir, new_resource.watch_dir].each do |path|
    directory path do
      owner new_resource.user
      group new_resource.group
      mode '0755'
      recursive true
    end
  end

  template '/etc/transmission-daemon/settings.json' do
    source 'settings.json.erb'
    cookbook 'transmission'
    owner new_resource.user
    group new_resource.group
    mode '0640'
    sensitive true
    variables(
      download_dir: new_resource.download_dir,
      incomplete_dir: new_resource.incomplete_dir,
      incomplete_dir_enabled: new_resource.incomplete_dir_enabled,
      peer_port: new_resource.peer_port,
      ratio_limit: new_resource.ratio_limit,
      ratio_limit_enabled: new_resource.ratio_limit_enabled,
      rpc_bind_address: new_resource.rpc_bind_address,
      rpc_password: new_resource.rpc_password,
      rpc_port: new_resource.rpc_port,
      rpc_username: new_resource.rpc_username,
      rpc_whitelist: new_resource.rpc_whitelist,
      rpc_whitelist_enabled: new_resource.rpc_whitelist_enabled,
      speed_limit_down: new_resource.speed_limit_down,
      speed_limit_down_enabled: new_resource.speed_limit_down_enabled,
      speed_limit_up: new_resource.speed_limit_up,
      speed_limit_up_enabled: new_resource.speed_limit_up_enabled,
      watch_dir: new_resource.watch_dir,
      watch_dir_enabled: new_resource.watch_dir_enabled
    )
    notifies :reload, 'service[transmission-daemon]', :delayed
  end

  link "#{new_resource.config_dir}/settings.json" do
    to '/etc/transmission-daemon/settings.json'
  end
end

action :delete do
  service 'transmission-daemon' do
    supports restart: true, reload: true
    action :nothing
  end

  link "#{new_resource.config_dir}/settings.json" do
    action :delete
  end

  file '/etc/transmission-daemon/settings.json' do
    action :delete
  end

  file new_resource.defaults_path do
    action :delete
  end

  [new_resource.watch_dir, new_resource.incomplete_dir, new_resource.download_dir, new_resource.config_dir].each do |path|
    directory path do
      recursive true
      action :delete
    end
  end
end
