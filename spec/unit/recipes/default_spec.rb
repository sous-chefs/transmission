require 'spec_helper'

describe 'transmission::default' do
  context 'When running on a Debian platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'debian', version: '8.0')
      runner.converge(described_recipe)
    end

    it 'sets default install_method to package' do
      expect(chef_run.node['transmission']['install_method']).to eq 'package'
    end

    it 'sets default user and group' do
      expect(chef_run.node['transmission']['user']).to eq 'debian-transmission'
      expect(chef_run.node['transmission']['group']).to eq 'debian-transmission'
    end

    it 'creates the transmission-default file' do
      expect(chef_run).to create_template('transmission-default')
        .with(path: '/etc/default/transmission-daemon')
        .with(source: 'transmission-daemon.default.erb')
        .with(owner: 'root')
        .with(group: 'root')
        .with(mode: '0644')
      expect(chef_run).to render_file('/etc/default/transmission-daemon')
        .with_content { |content|
          expect(content).to match('CONFIG_DIR="/var/lib/transmission-daemon/info"')
        }
    end
  end

  context 'When running on a non-Debian platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511')
      runner.converge(described_recipe)
    end

    it 'sets default install_method to package' do
      expect(chef_run.node['transmission']['install_method']).to eq 'source'
    end

    it 'sets default user and group' do
      expect(chef_run.node['transmission']['user']).to eq 'transmission'
      expect(chef_run.node['transmission']['group']).to eq 'transmission'
    end
  end

  context 'When running on RHEL' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'redhat', version: '7.2')
      runner.converge(described_recipe)
    end

    it 'creates the transmission-default file' do
      expect(chef_run).to create_template('transmission-default')
        .with(path: '/etc/sysconfig/transmission-daemon')
        .with(source: 'transmission-daemon.default.erb')
        .with(owner: 'root')
        .with(group: 'root')
        .with(mode: '0644')
      expect(chef_run).to render_file('/etc/sysconfig/transmission-daemon')
        .with_content { |content|
          expect(content).to match('CONFIG_DIR="/var/lib/transmission-daemon/info"')
        }
    end
  end

  context 'When running on Fedora' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'fedora', version: '24')
      runner.converge(described_recipe)
    end

    it 'creates the transmission-default file' do
      expect(chef_run).to create_template('transmission-default')
        .with(path: '/etc/sysconfig/transmission-daemon')
        .with(source: 'transmission-daemon.default.erb')
        .with(owner: 'root')
        .with(group: 'root')
        .with(mode: '0644')
      expect(chef_run).to render_file('/etc/sysconfig/transmission-daemon')
        .with_content { |content|
          expect(content).to match('CONFIG_DIR="/var/lib/transmission-daemon/info"')
        }
    end
  end

  context 'When overriding the config_dir' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'debian', version: '8.2') do |node|
        node.automatic['transmission']['config_dir'] = '/var/transmission-config'
      end
      runner.converge(described_recipe)
    end

    it 'creates the transmission-default file' do
      expect(chef_run).to create_template('transmission-default')
        .with(path: '/etc/default/transmission-daemon')
        .with(source: 'transmission-daemon.default.erb')
        .with(owner: 'root')
        .with(group: 'root')
        .with(mode: '0644')
      expect(chef_run).to render_file('/etc/default/transmission-daemon')
        .with_content { |content|
          expect(content).to match('CONFIG_DIR="/var/transmission-config"')
        }
    end
  end

  context 'When platform does not matter' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511')
      runner.converge(described_recipe)
    end

    it 'installs chef gems' do
      expect(chef_run).to install_chef_gem('bencode')
        .with(compile_time: true)
      expect(chef_run).to install_chef_gem('i18n')
        .with(compile_time: true)
      expect(chef_run).to install_chef_gem('transmission-simple')
        .with(compile_time: true)
      expect(chef_run).to install_chef_gem('activesupport')
        .with(compile_time: true)
    end

    it 'requires transmission-simple gem' do
      expect(chef_run).to run_ruby_block('require transmission-simple gem')
    end

    it 'configures the service' do
      expect(chef_run).to enable_service('transmission')
        .with(service_name: 'transmission-daemon')
        .with(supports: { restart: true,
                          reload: true })
        .with(action: [:enable, :start])
    end
  end

  context 'When install_method is from source' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
        node.automatic['transmission']['install_method'] = 'source'
      end
      runner.converge(described_recipe)
    end

    before :each do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
        .and_raise('include_recipe not matched')
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
        .with('transmission::source')
    end

    it 'includes the transmission::package recipe' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('transmission::source')
      chef_run
    end
  end

  context 'When install_method is from package' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'debian', version: '8.0') do |node|
        node.automatic['transmission']['install_method'] = 'package'
      end
      runner.converge(described_recipe)
    end

    before :each do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
        .and_raise('include_recipe not matched')
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
        .with('transmission::package')
    end

    it 'includes the transmission::package recipe' do
      expect_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('transmission::package')
      chef_run
    end
  end
end
