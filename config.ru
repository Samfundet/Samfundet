# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'rack-livereload'

run Rails.application
use Rack::LiveReload
