# frozen_string_literal: true

require 'spec_helper'

describe 'transmission_config' do
  step_into :transmission_config
  platform 'ubuntu', '24.04'

  recipe do
    transmission_config 'default' do
      rpc_password 'changeme'
    end
  end

  it { is_expected.to create_template('/etc/default/transmission-daemon') }
  it { is_expected.to create_directory('/etc/transmission-daemon') }
  it { is_expected.to create_directory('/var/lib/transmission-daemon/info') }
  it { is_expected.to create_template('/etc/transmission-daemon/settings.json') }
  it { is_expected.to create_link('/var/lib/transmission-daemon/info/settings.json').with(to: '/etc/transmission-daemon/settings.json') }

  it do
    expect(chef_run).to render_file('/etc/transmission-daemon/settings.json')
      .with_content('"rpc-password": "changeme"')
  end
end
