# frozen_string_literal: true

require 'spec_helper'

describe 'transmission_torrent_file' do
  step_into :transmission_torrent_file
  platform 'ubuntu', '24.04'

  recipe do
    transmission_torrent_file '/tmp/example.iso' do
      torrent 'https://example.com/example.iso.torrent'
      rpc_password 'changeme'
    end
  end

  it { is_expected.to install_chef_gem('bencode') }
  it { is_expected.to install_chef_gem('transmission-simple') }
  it { is_expected.to create_remote_file(::File.join(Chef::Config[:file_cache_path], 'example.iso.torrent')) }
  it { is_expected.to run_ruby_block('add torrent https://example.com/example.iso.torrent') }
end
