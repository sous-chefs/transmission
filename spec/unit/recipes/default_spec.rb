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

  context 'When platform does not matter' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'centos', version: '7.2.1511')
      runner.converge(described_recipe)
    end

    it 'requires transmission-simple gem' do
      expect(chef_run).to run_ruby_block('require transmission-simple gem')
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
