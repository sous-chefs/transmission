# frozen_string_literal: true

module Transmission
  module Cookbook
    module Helpers
      def default_install_method
        platform_family?('debian', 'rhel', 'amazon', 'fedora') ? 'package' : 'source'
      end

      def default_user
        platform_family?('debian') ? 'debian-transmission' : 'transmission'
      end

      def default_group
        platform_family?('debian') ? 'debian-transmission' : 'transmission'
      end

      def default_package_names
        %w(transmission transmission-cli transmission-daemon)
      end

      def transmission_defaults_path
        if platform_family?('rhel', 'fedora', 'amazon')
          '/etc/sysconfig/transmission-daemon'
        else
          '/etc/default/transmission-daemon'
        end
      end

      def transmission_home_path
        if platform_family?('rhel', 'fedora')
          '/var/lib/transmission'
        else
          '/var/lib/transmission-daemon'
        end
      end

      def transmission_config_path
        "#{transmission_home_path}/info"
      end

      def transmission_download_path
        "#{transmission_home_path}/downloads"
      end

      def transmission_incomplete_path
        "#{transmission_home_path}/incomplete"
      end

      def transmission_watch_path
        "#{transmission_home_path}/watch"
      end

      def transmission_build_pkgs
        if platform_family?('rhel', 'fedora', 'amazon')
          %w(cmake gcc gcc-c++ make curl-devel gettext libevent-devel libnatpmp-devel openssl-devel tar xz)
        elsif platform_family?('suse')
          %w(cmake gcc gcc-c++ make libcurl-devel gettext-tools libevent-devel libopenssl-devel tar xz)
        else
          %w(cmake g++ gcc make libcurl4-openssl-dev libevent-dev libnatpmp-dev libssl-dev pkg-config xz-utils)
        end
      end
    end
  end
end
