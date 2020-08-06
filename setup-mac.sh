#!/bin/bash

CONFIG_DIR="$(dirname "$0")/config"

# Install Homebrew
if [ ! -x /usr/local/bin/brew ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || exit
fi

# Install imagemagic brew
if [ ! -x /usr/local/Cellar/imagemagick ]; then
  brew install imagemagick || exit
fi

# Install graphviz brew
if [ ! -x /usr/local/Cellar/graphviz ]; then
  brew install graphviz || exit
fi

# Check that PostgresQL brew is installed
if [ ! -x /usr/local/bin/postgres ]; then
  brew install postgresql || exit
fi

# Install RVM
if [ ! -x ~/.rvm/bin/rvm ]; then
  \curl -sSL https://get.rvm.io | bash -s stable || exit
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

# Install gems
bundle install || exit

# Copy config files if necessary
if [ ! -e $CONFIG_DIR/database.yml ] &&
   [ ! -e $CONFIG_DIR/local_env.yml ] &&
   [ ! -e $CONFIG_DIR/billig.yml ] &&
   [ ! -e $CONFIG_DIR/secrets.yml ]; then
     make copy-config-files || exit
fi

# Setup and seed database if necessary
bundle exec rails db:version 2>/dev/null || bundle exec rails db:setup || exit

# Start the rails server if necessary
pgrep -x ruby >/dev/null || rails server || exit