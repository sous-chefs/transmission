#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook:: transmission
# Recipe:: default
#
# Copyright:: 2011-2019, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "transmission::#{node['transmission']['install_method']}"

template transmission_defaults do
  source 'transmission-daemon.default.erb'
  variables(config_dir: transmission_config_dir)
  notifies :reload, 'service[transmission]'
end

if node['transmission']['install_method'] == 'package'
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
  group node['transmission']['group']
  mode '0755'
end

directory "#{transmission_config_dir}/info" do
  recursive true
end

template "#{transmission_config_dir}/settings.json" do
  source 'settings.json.erb'
  owner node['transmission']['user']
  group node['transmission']['group']
  manage_symlink_source true
  variables(
    download_dir: transmission_download_dir,
    incomplete_dir: transmission_incomplete_dir,
    watch_dir: transmission_watch_dir
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
