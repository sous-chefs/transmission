# frozen_string_literal: true

require 'spec_helper'

describe 'transmission_service' do
  step_into :transmission_service
  platform 'ubuntu', '24.04'

  context 'with package install' do
    recipe do
      transmission_service 'default' do
        action %i(create enable start)
      end
    end

    it { is_expected.to create_template('/etc/systemd/system/transmission-daemon.service.d/10-override.conf') }
    it { is_expected.to enable_service('transmission-daemon') }
    it { is_expected.to start_service('transmission-daemon') }
  end

  context 'with source install' do
    recipe do
      transmission_service 'source' do
        install_method 'source'
        action :create
      end
    end

    it { is_expected.to create_systemd_unit('transmission-daemon.service') }
  end
end
