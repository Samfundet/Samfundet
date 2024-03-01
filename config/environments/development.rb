# -*- encoding : utf-8 -*-
# frozen_string_literal: true
Samfundet::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Whitelist docker compose ips (might not be needed).
  config.web_console.whitelisted_ips = '172.22.0.1/16'

  # Do not eager load code on boot.
  config.eager_load = false

  # Huge startup boost.
  # https://github.com/rails/rails/issues/29319
  config.assets.check_precompiled_asset = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true

  # Disable automatic asset invalidation to enable LiveGuard.
  config.assets.digest = false

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Print deprecation warnings to the log
  config.active_support.deprecation = :log

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  # set delivery method to :smtp, :sendmail or :test
  config.action_mailer.delivery_method = :letter_opener

  config.billig_path = 'http://localhost:4567/pay'
  config.billig_ticket_path = 'https://billig.samfundet.no/pdf?'

  config.purchase_callback_google_form_enabled = true
  config.purchase_callback_google_form_url = "https://docs.google.com/forms/d/e/1FAIpQLSeEDyT86GA2LcQH9-ZCyIEC3m8AmFCIrgqC7atB8HENMOkgSQ/viewform?embedded=true"

  # Note: nybygg_countdown_date is in UTC
  config.nybygg_countdown_enabled = true
  config.nybygg_countdown_date = DateTime.new(2024, 8, 12, 14, 0, 0)

  if !Rails.env.development?
    config.after_initialize do
      paamelding_table_prefix = 'paameldingsys.'

      # manually set BilligEvent table_name so it uses db view instead of std table
      RegistrationEvent.establish_connection(:paamelding)
      RegistrationEvent.table_name = paamelding_table_prefix + 'arrangementer'
    end
  end

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.middleware.insert_after ActionDispatch::Static, Rack::LiveReload

  ActiveRecord::Base.logger = nil
  config.log_level = :info
end
