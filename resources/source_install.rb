property :name, String, default: ''
use 'partial/_source'
unified_mode true

build_essential 'install compilation tools'

include_recipe 'yum-epel' if platform_family?('rhel', 'fedora', 'amazon')

package transmission_build_pkgs

remote_file "#{Chef::Config[:file_cache_path]}/transmission-#{new_resoruce.version}.tar.xz" do
  source "#{new_resoruce.url}/transmission-#{new_resoruce.version}.tar.xz"
  checksum new_resoruce.checksum
  action :create_if_missing
end

enable_natpmp = platform_family?('suse') ? '' : '--enable-external-natpmp'

bash 'compile_transmission' do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar xvJf transmission-#{new_resoruce.version}.tar.xz
    cd transmission-#{new_resoruce.version}
    ./configure -q --disable-static --enable-utp --enable-daemon \
      --enable-nls --enable-cli #{enable_natpmp}
    make -s
    make install
  EOH
  creates '/usr/local/bin/transmission-daemon'
end

systemd_unit 'transmission-daemon.service' do
  content <<~EOU
  [Unit]
  Description=Transmission BitTorrent Daemon
  After=network.target

  [Service]
  User=#{new_resoruce.user}
  Type=simple
  EnvironmentFile=-#{transmission_defaults}
  ExecStart=/usr/local/bin/transmission-daemon -f --log-error $OPTIONS
  ExecStop=/bin/kill -s STOP $MAINPID
  ExecReload=/bin/kill -s HUP $MAINPID

  [Install]
  WantedBy=multi-user.target
  EOU
  action :create
end

group new_resoruce.group do
  action :create
end

user new_resoruce.user do
  comment 'Transmission Daemon User'
  gid new_resoruce.group
  system true
  home transmission_home
  action :create
end

directory transmission_home do
  owner new_resoruce.user
  group new_resoruce.group
  mode '0755'
end

directory transmission_config_dir do
  mode '0755'
end

include_recipe 'transmission::default'
