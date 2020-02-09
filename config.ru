# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'
require 'rack-livereload'

use Rack::LiveReload

run Rails.application
