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

# Check that PostgreSQL brew is installed
if [ ! -x /usr/local/bin/postgres ]; then
  brew install postgresql || exit
fi

# Start the PostgreSQL service.
# We get all running services and filter out only the one that is named postgres
# Services can be annotated like 'started', 'stopped', et cetera, so use the former.
postgres_status=$(brew services list | grep 'postgres')
if [ started != *"$postgres_status"* ]; then
  brew services start postgres || exit
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
# rvm current returns a string on the format 'ruby-2.5.5', so just check the version number.
if [ 2.5.5 != *$(rvm current)* ]; then
  rvm default 2.5.5 || exit
fi

# Make sure that the correct Bundler version is installed so that we can actually use the 'bundle' command.
# gem list returns true or false depending on whether the gem is found with the version provided is installed or not.
if [ false == *$(gem list -i 'bundler' -v 1.17.3)* ]; then
  gem install bundler:1.17.3 || exit
fi

# Install gems
# bundle check checks if the Gemfile is satisfied, i.e. if the gems are cached.
# If not, install the gems.
bundle check || bundle install || exit

# Copy config files if necessary
# Only copy files if none have been copied so far.
if [ ! -e $CONFIG_DIR/database.yml ] &&
  [ ! -e $CONFIG_DIR/local_env.yml ] &&
  [ ! -e $CONFIG_DIR/billig.yml ] &&
  [ ! -e $CONFIG_DIR/secrets.yml ]; then
  make copy-config-files || exit
fi

# If samfundet user does not exist, create it.
samf_user_exists=$(psql postgres -tAc "SELECT 1 FROM pg_roles WHERE rolname='samfundet'" | grep -q 1)
if [ ! samf_user_exists ]; then
  echo -e "CREATE USER samfundet WITH PASSWORD '$SAMFDB_DEV_PASS';\nALTER USER samfundet CREATEDB;" | sudo -u postgres psql
fi

# Setup and seed database if necessary
bundle exec rails db:version 2>/dev/null || bundle exec rails db:setup || exit

# Start the rails server if necessary
# Search for a process with the ruby name and assume it's Samfundet.
pgrep -x ruby >/dev/null || rails server || exit
