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

  context 'When overriding configuration for settings.json' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'debian', version: '8.2') do |node|
        node.automatic['transmission']['download_dir'] = '/var/transmission-downloads'
        node.automatic['transmission']['incomplete_dir'] = '/var/transmission-incomplete-dir'
        node.automatic['transmission']['peer_port'] = 51_515
        node.automatic['transmission']['incomplete_dir_enabled'] = 'true'
        node.automatic['transmission']['ratio_limit'] = '5.5'
        node.automatic['transmission']['ratio_limit_enabled'] = true
        node.automatic['transmission']['rpc_bind_address'] = '127.0.0.1'
        node.automatic['transmission']['rpc_password'] = 'abc'
        node.automatic['transmission']['rpc_port'] = 1234
        node.automatic['transmission']['rpc_whitelist'] = '192.168.0.1'
        node.automatic['transmission']['rpc_whitelist_enabled'] = false
        node.automatic['transmission']['rpc_username'] = 'testuser'
        node.automatic['transmission']['speed_limit_down'] = 200
        node.automatic['transmission']['speed_limit_down_enabled'] = 'true'
        node.automatic['transmission']['speed_limit_up'] = 200
        node.automatic['transmission']['speed_limit_up_enabled'] = 'true'
        node.automatic['transmission']['watch_dir'] = '/var/transmission-watch'
        node.automatic['transmission']['watch_dir_enabled'] = 'true'
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
          expect(content).to match('CONFIG_DIR="/var/lib/transmission-daemon/info"')
        }
    end

    it 'creates the transmission settings.json' do
      expect(chef_run).to create_template('/var/lib/transmission-daemon/info/settings.json')
        .with(source: 'settings.json.erb')
        .with(owner: 'root')
        .with(group: 'root')
        .with(mode: '0644')
      expect(chef_run.template('/var/lib/transmission-daemon/info/settings.json')).to notify('service[transmission]')
        .to(:reload)
        .immediately
      expect(chef_run).to render_file('/var/lib/transmission-daemon/info/settings.json')
        .with_content { |content|
          expect(content).to match '    "download-dir": "/var/transmission-downloads",'
          expect(content).to match '    "incomplete-dir": "/var/transmission-incomplete-dir",'
          expect(content).to match '    "peer-port": 51515,'
          expect(content).to match '    "incomplete-dir-enabled": true,'
          expect(content).to match '    "ratio-limit": 5.5,'
          expect(content).to match '    "ratio-limit-enabled": true,'
          expect(content).to match '    "rpc-bind-address": "127.0.0.1",'
          expect(content).to match '    "rpc-password": "abc",'
          expect(content).to match '    "rpc-port": 1234,'
          expect(content).to match '    "rpc-username": "testuser",'
          expect(content).to match '    "rpc-whitelist": "192.168.0.1",'
          expect(content).to match '    "rpc-whitelist-enabled": false,'
          expect(content).to match '    "speed-limit-down": 200,'
          expect(content).to match '    "speed-limit-down-enabled": true,'
          expect(content).to match '    "speed-limit-up": 200,'
          expect(content).to match '    "speed-limit-up-enabled": true,'
          expect(content).to match '    "watch-dir": "/var/transmission-watch",'
          expect(content).to match '    "watch-dir-enabled": true'
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

    it 'creates the transmission settings.json' do
      expect(chef_run).to create_template('/var/transmission-config/settings.json')
        .with(source: 'settings.json.erb')
        .with(owner: 'root')
        .with(group: 'root')
        .with(mode: '0644')
      expect(chef_run.template('/var/transmission-config/settings.json')).to notify('service[transmission]')
        .to(:reload)
        .immediately
    end

    context 'when settings.json is not a symlink' do
      it 'does not create a symlink' do
        pending
      end
    end
  end

  context 'When using default settings' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511')
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

    it 'creates the transmission settings.json' do
      expect(chef_run).to create_template('/var/lib/transmission-daemon/info/settings.json')
        .with(source: 'settings.json.erb')
        .with(owner: 'root')
        .with(group: 'root')
        .with(mode: '0644')
      expect(chef_run.template('/var/lib/transmission-daemon/info/settings.json')).to notify('service[transmission]')
        .to(:reload)
        .immediately
      expect(chef_run).to render_file('/var/lib/transmission-daemon/info/settings.json')
        .with_content { |content|
          expect(content).to match '    "download-dir": "/var/lib/transmission-daemon/downloads",'
          expect(content).to match '    "incomplete-dir": "/var/lib/transmission-daemon/incomplete",'
          expect(content).to match '    "peer-port": 51413,'
          expect(content).to match '    "incomplete-dir-enabled": false,'
          expect(content).to match '    "ratio-limit": 2.0000,'
          expect(content).to match '    "ratio-limit-enabled": false,'
          expect(content).to match '    "rpc-bind-address": "0.0.0.0",'
          # don't match on password, as it's generated randomly
          expect(content).to match '    "rpc-port": 9091,'
          expect(content).to match '    "rpc-username": "transmission",'
          expect(content).to match '    "rpc-whitelist": "127.0.0.1",'
          expect(content).to match '    "rpc-whitelist-enabled": true,'
          expect(content).to match '    "speed-limit-down": 100,'
          expect(content).to match '    "speed-limit-down-enabled": false,'
          expect(content).to match '    "speed-limit-up": 100,'
          expect(content).to match '    "speed-limit-up-enabled": false,'
          expect(content).to match '    "watch-dir": "/var/lib/transmission-daemon/watch",'
          expect(content).to match '    "watch-dir-enabled": false'
        }
    end
  end

  context 'When platform does not matter' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511') do |node|
        node.automatic['transmission']['group'] = 'downloads'
      end
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

    it 'creates the transmission-daemon directory' do
      expect(chef_run).to create_directory('/etc/transmission-daemon')
        .with(owner: 'root')
        .with(group: 'downloads')
        .with(mode: '0755')
    end

    it 'creates the transmission settings.json' do
      expect(chef_run).to create_template('/var/lib/transmission-daemon/info/settings.json')
        .with(source: 'settings.json.erb')
        .with(owner: 'root')
        .with(group: 'root')
        .with(mode: '0644')
      expect(chef_run.template('/var/lib/transmission-daemon/info/settings.json')).to notify('service[transmission]')
        .to(:reload)
        .immediately
    end

    context 'when settings.json is a symlink' do
      it 'does not create a symlink' do
        pending
      end
    end

    context 'when settings.json is not a symlink' do
      it 'does not create a symlink' do
        allow_any_instance_of(File).to receive(:symlink?)
          .with('/var/lib/transmission-daemon/info/settings.json')
          .and_return(false)
        expect(chef_run).to create_link('/etc/transmission-daemon/settings.json')
          .with(to: '/var/lib/transmission-daemon/info/settings.json')
      end
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
