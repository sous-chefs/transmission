#
# Author:: Seth Chisamore (<schisamo@chef.io>)
# Cookbook:: transmission
# Recipe:: source
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

build_essential 'install compilation tools'

version = node['transmission']['version']

package transmission_build_pkgs

remote_file "#{Chef::Config[:file_cache_path]}/transmission-#{version}.tar.xz" do
  source "#{node['transmission']['url']}/transmission-#{version}.tar.xz"
  checksum node['transmission']['checksum']
  action :create_if_missing
end

bash 'compile_transmission' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xvJf transmission-#{version}.tar.xz
    cd transmission-#{version}
    ./configure -q && make -s
    make install
  EOH
  creates '/usr/local/bin/transmission-daemon'
end

group node['transmission']['group'] do
  action :create
end

user node['transmission']['user'] do
  comment 'Transmission Daemon User'
  gid node['transmission']['group']
  system true
  home transmission_home
  action :create
end

directory transmission_home do
  owner node['transmission']['user']
  group node['transmission']['group']
  mode '0755'
end

directory transmission_config_dir do
  owner node['transmission']['user']
  group node['transmission']['group']
  mode '0755'
end

include_recipe 'transmission::default'
