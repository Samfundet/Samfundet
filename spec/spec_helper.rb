# -*- encoding : utf-8 -*-
require 'rubygems'

ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment"
require 'rspec/rails'

# Requires shared example groups.
Dir["#{File.dirname(__FILE__)}/shared/**/*.rb"].each { |f| require f }

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

Authorization.ignore_access_control(true)

RSpec.configure do |config|
  config.mock_with :rspec

  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false

  config.fixture_path = Rails.root + '/spec/fixtures/'

  # Despite its name, methods defined in ModelHelpers are actually used in view
  # and controller tests as well; therefore, we include it for all tests, not
  # just 'type: :model'
  config.include(ModelHelpers)

  config.include(ModelMacros, type: :model)
  config.include(ViewMatchers, type: :view)
end

# Monkey-patch ActionController::TestCase so that 'locale: "en"' is added
# to all requests (to avoid having to do so manually).
class ActionController::TestCase
  module Behavior
    def process_with_default_locale(action, parameters = nil, session = nil,
                                    flash = nil, http_method = 'GET')
      parameters = { locale: "en" }.merge(parameters || {})
      process_without_default_locale(action, parameters, session, flash,
                                     http_method)
    end

    alias_method_chain :process, :default_locale
  end
end
