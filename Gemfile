# frozen_string_literal: true

###########################################
# NOTHING GOES IN HERE WITHOUT A COMMENT! #
###########################################

# Specify ruby version that we use. Bundler gives an error when a different ruby is used.
ruby '~> 2.7.0' # From .ruby-version.

# The repository from which we're fetching our rubygems.
source 'https://rubygems.org'

# Rails. Duh.
gem 'rails', '~> 5.2.0'

# Memcache client
gem 'dalli', '~> 2.7.0'

# Charts
gem 'lazy_high_charts', '~> 1.5.0'

# acts_as_list provides the means to sort and reorder a list of objects
# with respect to a column in the database, e.g. to sort and reorder a list
# of job applications based on the priority set by the applicant.
gem 'acts_as_list', '~> 1.0.0'

# Use activerecord as session store
gem 'activerecord-session_store', '~> 1.1.0'

# bcrypt() is a sophisticated and secure hash algorithm
# designed by The OpenBSD project for hashing passwords.
# bcrypt-ruby provides a simple wrapper for safely handling passwords.
gem 'bcrypt', '~> 3.1.0'

# we only use this gem for it's ujs capabilities.
# jquery is the defacto DOM manipulation libraray
gem 'jquery-rails', '~> 4.2.0'

# jquery ui for datepicker etc.
gem 'jquery-ui-rails', '~> 5.0.0'

# jquery support for turbolinks
gem 'jquery-turbolinks', '~> 2.1.0'

# used for sorting tables in the admission
gem 'jquery-tablesorter', '~> 1.27.0'

# CoffeeScript is a scripting language. It compiles to JavaScript.
gem 'coffee-rails', '~> 4.2.0'

# Explicitly request sass version
gem 'sass', '~> 3.4.0'

# Sass is a stylesheet language. It compiles to CSS.
gem 'sass-rails', '~> 5.0.0'

# Sass mixin library
gem 'bourbon', '~> 4.2.0'

# Semantic fluid grid framework
gem 'neat', '~> 1.8.0'

# uglifier is a Ruby wrapper for UglifyJS, a JavaScript compressor.
gem 'uglifier', '~> 3.0.0'

# CanCanCan for role-based access control. See app/models/ability.rb
gem 'cancancan', '~> 2.3.0'

# formtastic is a Rails form builder plugin
# with semantically rich and accessible markup.
gem 'formtastic', '~> 3.1.0'

# Haml is a templating language. It compiles to HTML.
gem 'haml-rails', '~> 2.0.0'

# icalendar is a library for dealing with iCalendar files.
gem 'icalendar', '~> 2.4.0'

# rails-translate-routes lets us use localized routes.
# For example, we can replace the path '/groups' with the paths
# '/gjenger' and '/en/groups' which both point to the same page.
# See: config/locales/routes/i18n-routes.yml
gem 'route_translator', '~> 7.1.0'

# RedCarpet renders Markdown, a light-weight markup language, to HTML.
# See: config/initializers/haml_markdown.rb
gem 'redcarpet', '~> 3.5.0'

# route_downcaser adds transparent support for case-insensive routes by downcasing requested URLs.
gem 'route_downcaser', '~> 1.2.0'

# SamfundetDomain is a gem which provides the application with samfundets domain models.
gem 'samfundet_domain', git: 'https://github.com/Samfundet/SamfundetDomain.git'
# gem 'samfundet_domain', git: 'https://github.com/Samfundet/SamfundetDomain.git', branch: 'update-ruby-version'
# gem 'samfundet_domain', path: '../SamfundetDomain'

# SamfundetAuth is a gem which provides the application with methods for authenticating against mdb2.
gem 'samfundet_auth', git: 'https://github.com/Samfundet/SamfundetAuth.git'
# gem 'samfundet_auth', git: 'https://github.com/Samfundet/SamfundetAuth.git', branch: 'update-ruby-version'
# gem 'samfundet_auth', path: '../SamfundetAuth'

# will_paginate is an adaptive pagination plugin.
# It makes pagination very simple.
gem 'will_paginate', '~> 3.1.0'

# for file uploads, see https://github.com/thoughtbot/paperclip
gem 'paperclip', '~> 6.1.0'

# automatic compression of images uploaded via paperclip
gem 'paperclip-compression', '~> 1.1.0'

# A simple date validator for Rails 3.
gem 'date_validator', '~> 0.9.0'

# PostgreSQL adapter. See: config/database.yml
gem 'pg', '~> 1.1.0'

# Provides PostgreSQL fulltext search. Contains wrappers for tsvectors
# and enables searching in nested attributes.
gem 'pg_search', '~> 2.3.0'

# Diff library used in history for information pages
gem 'diff-lcs', '~> 1.2.5'

# Middleware to send notifications when errors occur
gem 'exception_notification', '~> 4.2.0'

# Addon to exception_notification that sends exceptions to slack
gem 'slack-notifier', '~> 1.5.0'

# Cocoon makes nested forms for price groups under events a lot easier. Adds some buttons and stuff
gem 'cocoon', '~> 1.2.0'

# Render async allows easy async loading of partial views to improve page performance
gem 'render_async'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '~> 3.2.1'
  gem 'web-console', '~> 3.7.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.1.0'
  gem 'spring-watcher-listen', '~> 2.0.1'

  # Gem to detect ruby style guide violations
  gem 'rubocop', '~> 0.79.0'
  gem 'rubocop-rails_config', '~> 0.9.1'

  # annotate adds schema information from the database, in the form of
  # Ruby comments, to model files so that we can see which columns
  # are actually in the database.
  gem 'annotate', '~> 3.1.0'

  # Easier preview of mail in development
  gem 'letter_opener', '~> 1.7.0'

  # better_errors gives us better error pages when something goes wrong.
  # binding_of_caller is an optional dependency of better_errors which
  # allows for features such as local / instance variable expection,
  # REPL debugging etc.
  gem 'better_errors', '~> 2.5.1'
  gem 'binding_of_caller', '~> 0.8.0'

  # magic_encoding adds an 'encoding: utf-8' comment to all .rb files
  gem 'magic_encoding', '~> 0.0.0'

  # rails-footnotes adds information useful for debugging to the bottom
  # of our web pages for easy reference.
  # gem 'rails-footnotes'

  # file listener for automatic refresh of webpage on file change
  gem 'guard-livereload', '~> 2.5.2', require: false

  # livereload injection via rack middleware, no need for browser extesions
  gem 'rack-livereload', '~> 0.3.17'

  # For better mac filesystem listening performance
  gem 'rb-fsevent', '~> 0.10.3', require: false

  # Simple command execution over SSH. Lightweight deployment tool.
  gem 'mina', '~> 0.3.0'

  # A DSL for quickly creating web applications in Ruby with minimal effort.
  gem 'sinatra', '~> 2.2.0'

  # Turns objects into nicely formatted columns for easy reading.
  gem 'table_print', '~> 1.5.0'

  # Generate diagrams of models and controllers. Usage: Install graphviz and run 'rake diagram:all'.
  gem 'railroady', '~> 1.5.0'
end

group :development, :test do
  # seedbank loads seeds from respective environments and folders
  gem 'seedbank'

  # Faker is a library that generates fake data (names, email addresses, etc.)
  gem 'faker', '~> 1.6.6'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 9.0.0', platform: :mri

  # RSpec is a unit testing framework.
  # rspec-rails integrates RSpec (v2) and Rails (v3).
  gem 'rails-controller-testing', '~> 1.0.0'
  gem 'rspec-rails', '~> 3.9.0'
end

group :test do
  # Cucumber is a BDD testing framework.
  gem 'cucumber-rails', '~> 1.4.0', require: false

  # database_cleaner ensures a clean DB state during tests;
  # we use it with Cucumber.
  gem 'database_cleaner', '~> 1.8.0'

  # launchy is an application launcher; it's required for the
  # 'Then show me the page' action in Cucumber
  gem 'launchy', '~> 2.4.0'

  # The RSpec testing framework.
  gem 'rspec', '~> 3.9.0'

  # Factories for testing
  gem 'factory_bot_rails', '~> 5.1.0'

  # webrat provides functions such as 'visit', 'click_link',
  # 'click_button', etc. for use in integration tests.
  gem 'webrat', '~> 0.7.0'

  # Simplecov is a code coverage tool
  gem 'simplecov', '~> 0.18.0', require: false
end
