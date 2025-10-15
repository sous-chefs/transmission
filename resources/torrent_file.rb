unified_mode true

property :path, String, name_property: true
property :torrent, String
property :blocking, [true, false], default: true
property :continue_seeding, [true, false], default: false
property :owner, String, regex: Chef::Config[:user_valid_regex]
property :group, String, regex: Chef::Config[:group_valid_regex]
property :rpc_host, String, default: 'localhost'
property :rpc_port, Integer, default: 9091
property :rpc_username, String, default: 'transmission'
property :rpc_password, String

require 'transmission-simple'
require 'digest/sha1'
require 'chef/mixin/checksum'
include Chef::Mixin::Checksum
include Opscode::Transmission

def load_current_resource
  @current_resource = new_resource.class.new(new_resource.name)
  Chef::Log.debug("#{@new_resource} torrent hash = #{torrent_hash}")
  @transmission = Opscode::Transmission::Client.new("http://#{@new_resource.rpc_username}:#{@new_resource.rpc_password}@#{@new_resource.rpc_host}:#{@new_resource.rpc_port}/transmission/rpc")
  @torrent = nil
  begin
    @torrent = @transmission.get_torrent(torrent_hash)
    Chef::Log.info("Found existing #{@new_resource} in swarm with name of '#{@torrent.name}' and status of '#{@torrent.status_message}'")
    @current_resource.torrent(@new_resource.torrent)
  rescue
    Chef::Log.debug("Cannot find #{@new_resource} in the swarm")
  end
  @current_resource
end

action :create do
  unless exists?
    if @torrent
      if @new_resource.blocking || @torrent.downloading?
        Chef::Log.debug("Downloading #{@new_resource}...#{@torrent.percent_done * 100}% complete")
        move_and_clean_up if new_resource.continue_seeding # needed if torrent already in swarm
      else
        move_and_clean_up
        new_resource.updated_by_last_action(true)
      end
    else
      @torrent = @transmission.add_torrent(cached_torrent)
      Chef::Log.info("Added #{@new_resource} to the swarm with a name of '#{@torrent.name}'")
      if @new_resource.blocking
        loop do
          @torrent = @transmission.get_torrent(@torrent.hash_string)
          Chef::Log.debug("Downloading #{@new_resource}...#{@torrent.percent_done * 100}% complete")
          sleep 3
          break unless @torrent.downloading? || @torrent.checking?
        end
        move_and_clean_up
        new_resource.updated_by_last_action(true)
      end
    end
  end
end

action_class do
  def exists?
    ::File.exist?(new_resource.path)
  end

  def move_and_clean_up
    Chef::Log.info("#{@new_resource} download completed in #{Time.now.to_i - @torrent.start_date} seconds")
    torrent_download_path = ::File.join(@torrent.download_dir, @torrent.files.first.name)
    if new_resource.continue_seeding
      link new_resource.path do
        to torrent_download_path
        owner new_resource.owner
        group new_resource.group
      end
    else
      f = file @new_resource.path do
        content IO.read(torrent_download_path)
        backup false
        owner new_resource.owner
        group new_resource.group
      end
      f.run_action(:create)
      @transmission.remove_torrent(@torrent.hash_string, true)
    end
  end

  def cached_torrent
    @torrent_file_path ||= begin
      cache_file_path = "#{Chef::Config[:file_cache_path]}/#{::File.basename(new_resource.torrent)}"
      Chef::Log.debug("Caching a copy of torrent file #{new_resource.torrent} at #{cache_file_path}")
      r = if new_resource.torrent =~ %r{^(https?://)(.*/)(.*\.torrent)$}
            remote_file cache_file_path do
              source new_resource.torrent
              backup false
              mode '0755'
            end
          else
            file cache_file_path do
              content IO.read(new_resource.torrent)
              backup false
              mode '0755'
            end
          end
      r.run_action(:create)
      cache_file_path
    end
  end

  def torrent_hash
    require 'bencode'
    @torrent_hash ||= Digest::SHA1.hexdigest(BEncode.load_file(cached_torrent)['info'].bencode) # thx bakins!
  end
end
