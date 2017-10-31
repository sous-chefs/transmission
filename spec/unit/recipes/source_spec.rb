require 'spec_helper'

describe 'transmission::source' do
  context 'When platform does not matter, on default settings' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'debian', version: '8.0', file_cache_path: '/tmp/chef')
      runner.converge(described_recipe)
    end
  end

  context 'When on RHEL' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'redhat', version: '7.2')
      runner.converge(described_recipe)
    end

    it 'installs build packages' do
      packages = %w(curl curl-devel libevent libevent-devel intltool gettext tar xz openssl-devel)
      expect(chef_run).to install_package(packages)
    end
  end

  context 'When on Fedora' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'fedora', version: '24')
      runner.converge(described_recipe)
    end

    it 'installs build packages' do
      packages = %w(curl curl-devel libevent libevent-devel intltool gettext tar xz openssl-devel)
      expect(chef_run).to install_package(packages)
    end
  end

  context 'When on another platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'debian', version: '8.2')
      runner.converge(described_recipe)
    end

    it 'installs build packages' do
      packages = %w(automake libtool pkg-config libcurl4-openssl-dev intltool libxml2-dev libgtk2.0-dev libnotify-dev libglib2.0-dev libevent-dev libssl-dev xz-utils)
      expect(chef_run).to install_package(packages)
    end
  end
end
