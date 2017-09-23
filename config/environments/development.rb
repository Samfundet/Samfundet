# -*- encoding : utf-8 -*-
Samfundet::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local        = true
  config.action_controller.perform_caching  = false

  # Print deprecation warnings to the log
  config.active_support.deprecation = :log

  # Don't care if the mailer can't send
  # config.action_mailer.raise_delivery_errors = false

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  Haml::Template.options[:ugly] = false

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  # set delivery method to :smtp, :sendmail or :test
  config.action_mailer.delivery_method = :letter_opener

  config.billig_path = "http://localhost:4567/pay".freeze
  config.billig_ticket_path = 'https://billig.samfundet.no/pdf?'.freeze

  # Enable livereload injection in development
  config.middleware.use Rack::LiveReload
  config.middleware.delete Rack::Lock
end
