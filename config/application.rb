# -*- encoding : utf-8 -*-
# frozen_string_literal: true
require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Samfundet
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib #{config.root}/lib/validators #{config.root}/app/abilities)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Stockholm'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '{defaults,models,views,navigation,routes}', '**', '*.yml').to_s]
    config.i18n.available_locales = [:no, :en]
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :no
    config.i18n.fallbacks = false

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = 'utf-8'

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Files under app/assets/ which are not included in a Sprockets manifest
    # file must be added to config.assets.paths in order for helper functions
    # like 'javascript_include_tag' to find them
    config.assets.paths << Rails.root.join('app', 'assets', 'javascripts', 'interviews')
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
    config.assets.precompile += ['chartkick.js', 'linkgraph.js', 'old_samfundet/interviews.js', 'job_applications/job_applications.js', 'old_samfundet/jobs_search.js', 'applicants/admissions_admin_applicants.js', 'job_applications/admissions_admin_job_applications.js', 'sulten/duration.js', 'lyche/header.js']

    # Load local env variables into rails config
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      if File.exist?(env_file)
        YAML.load(File.open(env_file)).each do |key, value|
          ENV[key.to_s] = value
        end
      end

      billig_file = File.join(Rails.root, 'config', 'billig.yml')
      billig = YAML.load(File.open(billig_file))
      Rails.application.config.billig_message_no = billig['billig_message_no']
      Rails.application.config.billig_message_en = billig['billig_message_en']
      Rails.application.config.billig_offline = billig['billig_offline']
    end

    config.generators do |g|
      g.template_engine :haml
      g.test_framework  :rspec, views: false, helper: false
      g.view_specs false
      g.helper_specs false
    end

    # Fortastic options
    Formtastic::FormBuilder.use_required_attribute = true
    Formtastic::FormBuilder.perform_browser_validations = true

    # Time columns will become time zone aware in Rails 5.1. This still causes `String`s to be parsed as if they were in `Time.zone`, and `Time`s to be converted to `Time.zone`.
    # To keep the old behavior, you must add the following to your initializer:
    config.active_record.time_zone_aware_types = [:datetime]
  end

  Haml::Template.options[:format] = :html5
  Haml::Template.options[:escape_html] = true

  puts ""
  puts "   /$$$$$$                           /$$$$$$                           /$$             /$$     "
  puts "  /$$__  $$                         /$$__  $$                         | $$            | $$     "
  puts " | $$  \\__/  /$$$$$$  /$$$$$$/$$$$ | $$  \\__//$$   /$$ /$$$$$$$   /$$$$$$$  /$$$$$$  /$$$$$$   "
  puts " |  $$$$$$  |____  $$| $$_  $$_  $$| $$$$   | $$  | $$| $$__  $$ /$$__  $$ /$$__  $$|_  $$_/   "
  puts "  \\____  $$  /$$$$$$$| $$ \\ $$ \\ $$| $$_/   | $$  | $$| $$  \\ $$| $$  | $$| $$$$$$$$  | $$     "
  puts "  /$$  \\ $$ /$$__  $$| $$ | $$ | $$| $$     | $$  | $$| $$  | $$| $$  | $$| $$_____/  | $$ /$$ "
  puts " |  $$$$$$/|  $$$$$$$| $$ | $$ | $$| $$     |  $$$$$$/| $$  | $$|  $$$$$$$|  $$$$$$$  |  $$$$/ "
  puts "  \\______/  \\_______/|__/ |__/ |__/|__/      \\______/ |__/  |__/ \\_______/ \\_______/   \\___/   "
  puts "                                                                                               "
  puts ""

end
