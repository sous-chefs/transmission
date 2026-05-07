# frozen_string_literal: true

property :user, String, default: lazy { default_user }
property :group, String, default: lazy { default_group }
property :home, String, default: lazy { transmission_home_path }
property :config_dir, String, default: lazy { transmission_config_path }
property :defaults_path, String, default: lazy { transmission_defaults_path }
