# frozen_string_literal: true

provides :transmission_torrent_file
unified_mode true

property :path, String, name_property: true
property :torrent, String, required: true
property :blocking, [true, false], default: true
property :continue_seeding, [true, false], default: false
property :owner, String, regex: Chef::Config[:user_valid_regex]
property :group, String, regex: Chef::Config[:group_valid_regex]
property :rpc_host, String, default: 'localhost'
property :rpc_port, Integer, default: 9091
property :rpc_username, String, default: 'transmission'
property :rpc_password, String, sensitive: true

default_action :create

action_class do
  include Chef::Mixin::Checksum

  def transmission_client
    require 'transmission-simple'

    Opscode::Transmission::Client.new(
      "http://#{new_resource.rpc_username}:#{new_resource.rpc_password}@#{new_resource.rpc_host}:#{new_resource.rpc_port}/transmission/rpc"
    )
  end

  def existing_torrent
    @existing_torrent ||= transmission_client.get_torrent(torrent_hash)
  rescue StandardError
    nil
  end

  def cached_torrent_path
    "#{Chef::Config[:file_cache_path]}/#{::File.basename(new_resource.torrent)}"
  end

  def cache_torrent_file
    if new_resource.torrent.match?(%r{^https?://.*/.*\.torrent$})
      remote_file cached_torrent_path do
        source new_resource.torrent
        backup false
        mode '0755'
      end
    else
      cookbook_file cached_torrent_path do
        source new_resource.torrent
        backup false
        mode '0755'
        action :nothing
      end

      ruby_block "cache torrent #{new_resource.torrent}" do
        block { ::File.write(cached_torrent_path, ::File.binread(new_resource.torrent)) }
        not_if { ::File.exist?(cached_torrent_path) && checksum(cached_torrent_path) == checksum(new_resource.torrent) }
      end
    end
  end

  def torrent_hash
    require 'bencode'
    require 'digest/sha1'

    @torrent_hash ||= Digest::SHA1.hexdigest(BEncode.load_file(cached_torrent_path)['info'].bencode)
  end

  def wait_for_torrent(torrent)
    loop do
      torrent = transmission_client.get_torrent(torrent.hash_string)
      Chef::Log.debug("Downloading #{new_resource}...#{torrent.percent_done * 100}% complete")
      sleep 3
      break unless torrent.downloading? || torrent.checking?
    end

    torrent
  end

  def move_and_clean_up(torrent)
    Chef::Log.info("#{new_resource} download completed in #{Time.now.to_i - torrent.start_date} seconds")
    torrent_download_path = ::File.join(torrent.download_dir, torrent.files.first.name)

    if new_resource.continue_seeding
      link new_resource.path do
        to torrent_download_path
        owner new_resource.owner
        group new_resource.group
      end
    else
      file new_resource.path do
        content lazy { ::File.binread(torrent_download_path) }
        backup false
        owner new_resource.owner
        group new_resource.group
      end

      transmission_client.remove_torrent(torrent.hash_string, true)
    end
  end
end

action :create do
  chef_gem 'bencode'
  chef_gem 'transmission-simple'

  cache_torrent_file

  ruby_block "add torrent #{new_resource.torrent}" do
    block do
      torrent = existing_torrent || transmission_client.add_torrent(cached_torrent_path)
      Chef::Log.info("Added #{new_resource} to the swarm with a name of '#{torrent.name}'") unless existing_torrent

      if new_resource.blocking
        torrent = wait_for_torrent(torrent)
        move_and_clean_up(torrent)
      elsif !torrent.downloading? && !torrent.checking?
        move_and_clean_up(torrent)
      end
    end
    not_if { ::File.exist?(new_resource.path) }
  end
end

action :delete do
  file new_resource.path do
    action :delete
  end
end
