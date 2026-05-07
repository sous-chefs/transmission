# frozen_string_literal: true

require 'spec_helper'
require_relative '../../libraries/helpers'

describe Transmission::Cookbook::Helpers do
  let(:helper) do
    Class.new do
      include Transmission::Cookbook::Helpers

      def platform_family?(*families)
        families.include?('debian')
      end
    end.new
  end

  it 'returns Debian package defaults' do
    expect(helper.default_install_method).to eq('package')
    expect(helper.default_user).to eq('debian-transmission')
    expect(helper.transmission_home_path).to eq('/var/lib/transmission-daemon')
  end
end
