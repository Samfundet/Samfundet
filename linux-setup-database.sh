#Check for updates
sudo apt update
sudo apt upgrade

#Make sure the default ruby version to use is Ruby 2.5.5
rvm use 2.5.5 --default

#Install required ruby gems
bundle update
bundle install

#Copy and paste the config files, and rename them
if [ ! -e $CONFIG_DIR/database.yml ] &&
   [ ! -e $CONFIG_DIR/local_env.yml ] &&
   [ ! -e $CONFIG_DIR/billig.yml ] &&
   [ ! -e $CONFIG_DIR/secrets.yml ]; then
     make copy-config-files || exit
fi

#For setting up the database for the first time
bundle exec rails db:setup

#Run the server
make run
