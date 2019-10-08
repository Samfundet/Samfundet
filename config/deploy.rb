# frozen_string_literal: true
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

print "Username @ Samfundet.no (defaults to current user's username): "
username = STDIN.gets.chomp
set :user, username unless username == ''

set :ssh_options, '-o StrictHostKeyChecking=no'

print 'Select a branch (default is master): '
inpt = STDIN.gets.chomp
set :branch, inpt.empty? ? 'master' : inpt

set :domain, 'samfundet.no'
set :repository, 'git@github.com:Samfundet/Samfundet.git'
set :shared_paths, ['config/database.yml', 'config/billig.yml', 'config/local_env.yml', 'config/secrets.yml', 'log', 'public/upload']

# https://github.com/mina-deploy/mina/issues/99
set :term_mode, :nil
set :keep_releases, 3

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.

# Optional settings:
#   set :port, '30000'     # SSH port number.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.

namespace :environment do
  desc 'Set up staging-specific variables'
  task :staging do
    set :rails_env, 'staging'
    set :deploy_to, '/var/www/samfundet.no/www-beta'
    queue %{umask 002}
  end

  desc 'Set up production-specific variables'
  task :production do
    set :rails_env, 'production'
    set :deploy_to, '/var/www/samfundet.no/www-rails/'
    queue %(umask 002)
  end
end

# task :environment do
# If you're using rbenv, use this to load the rbenv environment.
# Be sure to commit your .rbenv-version to your repository.
# invoke :'rbenv:load'

# For those using RVM, use this to load an RVM version@gemset.
# invoke :'rvm:use[ruby-1.9.3-p125@default]'
# end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
namespace :setup do
  task production: :'environment:production' do
    queue! %(mkdir -p "#{deploy_to}/releases")
    queue! %(chmod 775 "#{deploy_to}/releases")

    queue! %(mkdir -p "#{deploy_to}/shared/log")
    queue! %(chmod 770 "#{deploy_to}/shared/log")

    queue! %(mkdir -p "#{deploy_to}/shared/config")
    queue! %(chmod 770 "#{deploy_to}/shared/config")

    queue! %(mkdir -p "#{deploy_to}/shared/public/upload")
    queue! %(chmod 775 "#{deploy_to}/shared/public/upload")

    queue! %(touch "#{deploy_to}/shared/config/database.yml")
    queue! %(chmod 770 "#{deploy_to}/shared/config/database.yml")

    queue! %(touch "#{deploy_to}/shared/config/billig.yml")
    queue! %(chmod 775 "#{deploy_to}/shared/config/billig.yml")

    queue! %(touch "#{deploy_to}/shared/config/local_env.yml")
    queue! %(chmod 770 "#{deploy_to}/shared/config/local_env.yml")

    queue! %(touch "#{deploy_to}/shared/config/secrets.yml")
    queue! %(chmod 770 "#{deploy_to}/shared/config/secrets.yml")

    queue  %(echo "-----> Be sure to edit 'shared/config/database.yml'.")
  end
end

task :run_mina do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      invoke :'passenger:restart'
    end
  end
end

namespace :deploy do
  desc 'Deploy staging environment.'
  task staging: :'environment:staging' do
    invoke :run_mina
  end

  desc 'Deploy production environment.'
  task production: :'environment:production' do
    invoke :run_mina
    invoke :'memcache:flush'
  end
end

namespace :memcache do
  desc 'Flush memcache'
  task flush: :'environment:production' do
    queue %(sg lim-web 'echo "flush_all" | nc localhost 11211')
  end
end

namespace :passenger do
  desc 'Restart Passenger'
  task :restart do
    queue %(
      echo "-----> Restarting passenger"
      #{echo_cmd %(mkdir -p tmp)}
      #{echo_cmd %(touch tmp/restart.txt)}
    )
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
