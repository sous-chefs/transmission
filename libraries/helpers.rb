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
    end
  end
end

Chef::DSL::Recipe.include Transmission::Cookbook::Helpers
Chef::Resource.include Transmission::Cookbook::Helpers
