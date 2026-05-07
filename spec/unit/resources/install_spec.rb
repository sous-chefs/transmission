# frozen_string_literal: true

require 'spec_helper'

describe 'transmission_install' do
  step_into :transmission_install
  platform 'ubuntu', '24.04'

  context 'with package install' do
    recipe do
      transmission_install 'default'
    end

    it { is_expected.to install_package(%w(transmission transmission-cli transmission-daemon)) }
  end

  context 'with source install' do
    recipe do
      transmission_install 'source' do
        install_method 'source'
        checksum 'abc123'
      end
    end

    it { is_expected.to install_package(%w(cmake g++ gcc make libcurl4-openssl-dev libevent-dev libnatpmp-dev libssl-dev pkg-config xz-utils)) }
    it { is_expected.to create_group('debian-transmission') }
    it { is_expected.to create_user('debian-transmission') }
    it { is_expected.to create_remote_file_if_missing(::File.join(Chef::Config[:file_cache_path], 'transmission-4.1.1.tar.xz')) }
    it { is_expected.to run_execute('extract transmission 4.1.1') }
    it { is_expected.to run_execute('build transmission 4.1.1') }
  end
end
