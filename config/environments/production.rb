# -*- encoding : utf-8 -*-
# frozen_string_literal: true
Samfundet::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # Define our logger and set it to rotate the log monthly
  config.logger = Logger.new('/var/log/rails/production.log')

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local        = false
  config.action_controller.perform_caching  = true
  config.action_view.cache_template_loading = true

  config.active_support.deprecation = :notify

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  config.cache_store = :mem_cache_store, 'localhost:11211', { namespace: 'production' }

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

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
  config.action_mailer.default_url_options = { host: 'samfundet.no', protocol: 'https' }

  # set delivery method to :smtp, :sendmail or :test
  config.action_mailer.delivery_method = :sendmail

  # these options are only needed if you choose smtp delivery
  config.action_mailer.sendmail_settings = {
    location: '/usr/sbin/sendmail',
    arguments: '-i'
  }

  config.billig_path = 'https://billettsalg.samfundet.no/pay'
  config.billig_ticket_path = 'https://billig.samfundet.no/pdf?'

  config.after_initialize do
    billig_table_prefix = 'billig.'

    # manually set BilligEvent table_name so it uses db view instead of std table
    BilligEvent.establish_connection(:billig)
    BilligEvent.table_name = billig_table_prefix + 'event_lim_web'

    billig_tables = [BilligTicketGroup, BilligPriceGroup, BilligPaymentError, BilligPaymentErrorPriceGroup, BilligTicket, BilligPurchase, BilligTicketCard]
    billig_tables.each do |table|
      table.establish_connection(:billig)
      table.table_name = billig_table_prefix + table.name.gsub(/Billig/, '').underscore
    end
  end
end

SamfundetAuth.setup do |config|
  config.member_database = :mdb2
  config.member_table = :lim_medlemsinfo
end

Paperclip.options[:command_path] = '/usr/bin/'
