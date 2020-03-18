#!/bin/bash

CONFIG_DIR="$(dirname "$0")/config"

# Install RVM
if [ ! -x ~/.rvm/bin/rvm ]; then
  \curl -sSL https://get.rvm.io | bash -s stable || exit
fi

# Install Homebrew
if [ ! -x /usr/local/bin/brew ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || exit
fi

# Install Ruby 2.5.5
if [ ! -x ~/.rvm/rubies/ruby-2.5.5/bin/ruby ]; then
  rvm install 2.5.5 || exit
fi

# Check that the current Ruby installation
# ruby -v returns a string like 'ruby 2.5.5p157 (2019-03-15 revision 67260) [x86_64-darwin18]
# Just check if 2.5.5 is present in the string, should be enough.
if [[ "2.5.5" == *"$(ruby -v)"* ]]; then
  rvm use 2.5.5 --default || exit
fi

# Check that PostgresQL brew is installed
if [ ! -x /usr/local/bin/postgres ]; then
  brew install postgresql || exit
fi

# Install gems
bundle install || exit

# Copy config files
make copy-config-files || exit

# Install imagemagic brew
if [ ! -x /usr/local/Cellar/imagemagick ]; then
  brew install imagemagick || exit
fi

# Setup and seed database
rails db:environment:set RAILS_ENV=development && rails db:setup || exit

# Start the rails server
rails server || exit