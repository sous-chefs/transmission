require 'spec_helper'

describe 'transmission::package' do
  context 'When platform does not matter' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'debian', version: '8.0')
      runner.converge(described_recipe)
    end

    it 'installs the required packages' do
      expect(chef_run).to install_package(%w(transmission transmission-cli transmission-daemon))
    end

    before :each do
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
        .and_raise('include_recipe not matched')
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe)
        .with('transmission::default')
    end
  end
end
