
# frozen_string_literal: true

require 'mina/bundler'
require 'mina/rails'
require 'mina/git'

# Basic connection settings.
print "Username @ Samfundet.no (defaults to current user's username): "
username = STDIN.gets.to_s.strip
set :user, username unless username.empty?

print 'Select a branch (default is master): '
branch = STDIN.gets.to_s.strip
set :branch, branch.empty? ? 'master' : branch

set :domain, 'samfundet.no'
set :repository, 'git@github.com:Samfundet/Samfundet.git'
set :ssh_options, '-o StrictHostKeyChecking=no'

# Mina's system execution mode supports interactive SSH password prompts.
set :execution_mode, :system
set :keep_releases, 3

# Retain shared data across releases.
# mina/bundler also shares vendor/bundle.
# Before the first deploy, copy current/config/credentials into
# shared/config/credentials so existing credentials survive release cleanup.
set :shared_dirs, (fetch(:shared_dirs, []) + %w[log public/upload config/credentials]).uniq
set :shared_files, (fetch(:shared_files, []) + %w[
  config/database.yml
  config/billig.yml
  config/local_env.yml
  config/secrets.yml
]).uniq

namespace :environment do
  desc 'Set up staging-specific variables'
  task :staging do
    set :rails_env, 'staging'
    set :deploy_to, '/var/www/samfundet.no/www-beta'

    # The server's bundle launcher has a Ruby 3.1 shebang.
    set :bundle_bin, '/usr/bin/ruby /usr/local/bin/bundle'
  end

  desc 'Set up production-specific variables'
  task :production do
    set :rails_env, 'production'
    set :deploy_to, '/var/www/samfundet.no/www-rails/'

    # Leave the production Ruby/Bundler setup unchanged.
    set :bundle_bin, 'bundle'
  end
end

# Retains the explicit production setup permissions from the old deploy file.
# Mina 1.x also provides its own `setup` task for standard shared paths.
namespace :setup do
  desc 'Prepare production directories and shared config permissions'
  task :production do
    invoke :'environment:production'
    root = fetch(:deploy_to)

    command %(mkdir -p "#{root}/releases")
    command %(chmod 775 "#{root}/releases")

    command %(mkdir -p "#{root}/shared/log")
    command %(chmod 770 "#{root}/shared/log")

    command %(mkdir -p "#{root}/shared/config")
    command %(chmod 770 "#{root}/shared/config")

    command %(mkdir -p "#{root}/shared/config/credentials")
    command %(chmod 770 "#{root}/shared/config/credentials")

    command %(mkdir -p "#{root}/shared/public/upload")
    command %(chmod 775 "#{root}/shared/public/upload")

    command %(touch "#{root}/shared/config/database.yml")
    command %(chmod 770 "#{root}/shared/config/database.yml")

    command %(touch "#{root}/shared/config/billig.yml")
    command %(chmod 775 "#{root}/shared/config/billig.yml")

    command %(touch "#{root}/shared/config/local_env.yml")
    command %(chmod 770 "#{root}/shared/config/local_env.yml")

    command %(touch "#{root}/shared/config/secrets.yml")
    command %(chmod 770 "#{root}/shared/config/secrets.yml")

    command %(echo "-----> Be sure to edit 'shared/config/database.yml'.")
  end
end

# Common release procedure for both environments.
task :run_mina do
  deploy do
    # Allow group members to write files created during deployment.
    command 'umask 002'

    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      invoke :'passenger:restart'
    end
  end
end

namespace :deploy do
  desc 'Deploy staging environment'
  task :staging do
    invoke :'environment:staging'
    invoke :run_mina
  end

  desc 'Deploy production environment'
  task :production do
    invoke :'environment:production'
    invoke :run_mina
    invoke :'memcache:flush'
  end
end

namespace :memcache do
  desc 'Flush the production memcache'
  task :flush do
    invoke :'environment:production'
    command %(sg lim-web 'echo "flush_all" | nc localhost 11211')
  end
end

namespace :passenger do
  desc 'Restart Passenger for the newly activated release'
  task :restart do
    comment 'Restarting Passenger'
    in_path(fetch(:current_path)) do
      command 'mkdir -p tmp'
      command 'touch tmp/restart.txt'
    end
  end
end
