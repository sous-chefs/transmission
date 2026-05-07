# frozen_string_literal: true

provides :transmission_install
unified_mode true

use '_partial/_paths'
include Transmission::Cookbook::Helpers

property :install_method, String, equal_to: %w(package source), default: lazy { default_install_method }
property :package_names, Array, default: lazy { default_package_names }
property :source_url, String, default: 'https://github.com/transmission/transmission-releases/raw/master'
property :version, String, default: '4.1.1'
property :checksum, String
property :build_packages, Array, default: lazy { transmission_build_pkgs }
property :source_prefix, String, default: '/usr/local'

default_action :install

action_class do
  include Transmission::Cookbook::Helpers

  def source_archive
    "#{Chef::Config[:file_cache_path]}/transmission-#{new_resource.version}.tar.xz"
  end

  def source_directory
    "#{Chef::Config[:file_cache_path]}/transmission-#{new_resource.version}"
  end

  def source_install_marker
    "#{new_resource.source_prefix}/bin/transmission-daemon"
  end
end

action :install do
  if new_resource.install_method == 'package'
    package new_resource.package_names
  else
    package new_resource.build_packages

    group new_resource.group

    user new_resource.user do
      comment 'Transmission Daemon User'
      gid new_resource.group
      system true
      home new_resource.home
    end

    directory new_resource.home do
      owner new_resource.user
      group new_resource.group
      mode '0755'
      recursive true
    end

    remote_file source_archive do
      source "#{new_resource.source_url}/transmission-#{new_resource.version}.tar.xz"
      checksum new_resource.checksum if new_resource.checksum
      action :create_if_missing
    end

    execute "extract transmission #{new_resource.version}" do
      command "tar xf #{source_archive} -C #{Chef::Config[:file_cache_path]}"
      creates source_directory
    end

    execute "build transmission #{new_resource.version}" do
      cwd source_directory
      command "cmake -B build -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=#{new_resource.source_prefix} && cmake --build build && cmake --install build"
      creates source_install_marker
    end
  end
end

action :remove do
  if new_resource.install_method == 'package'
    package new_resource.package_names do
      action :remove
    end
  else
    file source_install_marker do
      action :delete
    end
  end
end
