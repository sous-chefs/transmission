module Transmission
  module Cookbook
    module Helpers
      def transmission_defaults
        if platform_family?('rhel', 'fedora')
          '/etc/sysconfig/transmission-daemon'
        else
          '/etc/default/transmission-daemon'
        end
      end

      def transmission_home
        if platform_family?('rhel', 'fedora')
          '/var/lib/transmission'
        else
          '/var/lib/transmission-daemon'
        end
      end

      def transmission_config_dir
        "#{transmission_home}/info"
      end

      def transmission_download_dir
        "#{transmission_home}/downloads"
      end

      def transmission_incomplete_dir
        "#{transmission_home}/incomplete"
      end

      def transmission_watch_dir
        "#{transmission_home}/watch"
      end

      def transmission_build_pkgs
        if platform_family?('rhel', 'fedora', 'amazon')
          %w(curl-devel dbus-glib-devel gettext glib2-devel intltool libevent-devel libnatpmp-devel libnotify-devel libxml2-devel openssl-devel tar xz)
        elsif platform_family?('suse')
          %w(libcurl-devel dbus-1-glib-devel gettext-tools glib2-devel intltool libevent-devel libnotify-devel libxml2-devel libopenssl-devel tar xz)
        else
          %w(automake intltool libcurl4-openssl-dev libdbus-glib-1-dev libevent-dev libglib2.0-dev libnatpmp-dev libnotify-dev libssl-dev libtool libxml2-dev pkg-config xz-utils)
        end
      end
    end
  end
end

Chef::DSL::Recipe.include Transmission::Cookbook::Helpers
Chef::Resource.include Transmission::Cookbook::Helpers
