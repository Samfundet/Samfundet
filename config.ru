# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
# require 'rack-livereload'

# use Rack::LiveReload, host: 'localhost', live_reload_port: 3000

run Rails.application
