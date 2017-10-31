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
end
