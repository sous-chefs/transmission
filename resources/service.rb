# frozen_string_literal: true

provides :transmission_service
unified_mode true

use '_partial/_paths'
include Transmission::Cookbook::Helpers

property :install_method, String, equal_to: %w(package source), default: lazy { default_install_method }
property :binary_path, String, default: lazy { install_method == 'source' ? '/usr/local/bin/transmission-daemon' : '/usr/bin/transmission-daemon' }

default_action %i(create enable start)

action_class do
  include Transmission::Cookbook::Helpers

  def unit_content
    {
      Unit: {
        Description: 'Transmission BitTorrent Daemon',
        After: 'network.target',
      },
      Service: {
        User: new_resource.user,
        Type: 'simple',
        EnvironmentFile: "-#{new_resource.defaults_path}",
        ExecStart: "#{new_resource.binary_path} -f --log-error $OPTIONS",
        ExecStop: '/bin/kill -s STOP $MAINPID',
        ExecReload: '/bin/kill -s HUP $MAINPID',
      },
      Install: {
        WantedBy: 'multi-user.target',
      },
    }
  end
end

action :create do
  service 'transmission-daemon' do
    supports restart: true, reload: true
    action :nothing
  end

  if new_resource.install_method == 'package'
    directory '/etc/systemd/system/transmission-daemon.service.d' do
      owner 'root'
      group 'root'
      mode '0755'
      recursive true
    end

    template '/etc/systemd/system/transmission-daemon.service.d/10-override.conf' do
      source '10-override.conf.erb'
      cookbook 'transmission'
      variables(defaults: new_resource.defaults_path)
      notifies :run, 'execute[systemctl daemon-reload]', :immediately
      notifies :reload, 'service[transmission-daemon]', :delayed
    end

    execute 'systemctl daemon-reload' do
      action :nothing
    end
  else
    systemd_unit 'transmission-daemon.service' do
      content unit_content
      action :create
    end
  end
end

action :enable do
  service 'transmission-daemon' do
    supports restart: true, reload: true
    action :enable
  end
end

action :start do
  service 'transmission-daemon' do
    supports restart: true, reload: true
    action :start
  end
end

action :restart do
  service 'transmission-daemon' do
    supports restart: true, reload: true
    action :restart
  end
end

action :reload do
  service 'transmission-daemon' do
    supports restart: true, reload: true
    action :reload
  end
end

action :stop do
  service 'transmission-daemon' do
    supports restart: true, reload: true
    action :stop
  end
end

action :disable do
  service 'transmission-daemon' do
    supports restart: true, reload: true
    action :disable
  end
end

action :delete do
  service 'transmission-daemon' do
    supports restart: true, reload: true
    action %i(stop disable)
  end

  file '/etc/systemd/system/transmission-daemon.service.d/10-override.conf' do
    action :delete
    only_if { new_resource.install_method == 'package' }
  end

  systemd_unit 'transmission-daemon.service' do
    action :delete
    only_if { new_resource.install_method == 'source' }
  end
end
