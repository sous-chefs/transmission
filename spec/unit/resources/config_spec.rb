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
  it { is_expected.to create_directory('/var/lib/transmission-daemon/info') }
  it { is_expected.to create_template('/var/lib/transmission-daemon/info/settings.json') }

  it do
    expect(chef_run).to render_file('/var/lib/transmission-daemon/info/settings.json')
      .with_content('"rpc-password": "changeme"')
  end
end
