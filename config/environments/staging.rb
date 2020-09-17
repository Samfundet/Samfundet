# -*- encoding : utf-8 -*-
# frozen_string_literal: true
Samfundet::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local        = false
  config.action_controller.perform_caching  = true
  config.action_view.cache_template_loading = true

  config.active_support.deprecation = :notify

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  logger = ActiveSupport::Logger.new('/var/log/rails/staging.log')

  # Use a different cache store in production
  config.cache_store = :mem_cache_store, 'localhost:11211', { namespace: 'staging' }

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Enable automatic asset invalidation
  config.assets.digest = true

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: 'www-beta.samfundet.no', protocol: 'https' }

  # set delivery method to :smtp, :sendmail or :test
  config.action_mailer.delivery_method = :sendmail

  # these options are only needed if you choose smtp delivery
  config.action_mailer.sendmail_settings = {
    location: '/usr/sbin/sendmail',
    arguments: '-i'
  }

  config.billig_path = 'https://billettsalg-test.uka.no/pay'
  config.billig_ticket_path = 'https://erlinvan.billig.samfundet.no/pdf?'

  config.after_initialize do
    billig_table_prefix = 'billig.'

    # manually set BilligEvent table_name so it uses db view instead of std table
    BilligEvent.establish_connection(:mdb2_swpay)
    BilligEvent.table_name = billig_table_prefix + 'event_lim_web'

    billig_tables = [BilligTicketGroup, BilligPriceGroup, BilligPaymentError, BilligPaymentErrorPriceGroup, BilligTicket, BilligPurchase, BilligTicketCard]
    billig_tables.each do |table|
      table.establish_connection(:mdb2_swpay)
      table.table_name = billig_table_prefix + table.name.gsub(/Billig/, '').underscore
    end
    paamelding_table_prefix = 'paameldingsys.'

    # manually set RegistrationEvent table_name so it uses db view instead of std table
    RegistrationEvent.establish_connection(:paamelding)
    RegistrationEvent.table_name = paamelding_table_prefix + 'arrangementer'
  end
end

SamfundetAuth.setup do |config|
  config.member_database = :mdb2
  config.member_table = :lim_medlemsinfo
end

Paperclip.options[:command_path] = '/usr/bin/'
