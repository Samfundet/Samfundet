#Install required ruby gems
bundle install

#Copy and paste the config files, and rename them
if [ ! -e $CONFIG_DIR/database.yml ] &&
   [ ! -e $CONFIG_DIR/local_env.yml ] &&
   [ ! -e $CONFIG_DIR/billig.yml ] &&
   [ ! -e $CONFIG_DIR/secrets.yml ]; then
     make copy-config-files || exit
fi

#For setting up the database for the first time
rvm use 2.5.5 --default
bundle exec rails db:setup

#Run the server
make run
