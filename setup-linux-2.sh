#Check for updates
sudo apt-get update
sudo apt-get upgrade

#Install ruby
rvm user gemsets
rvm install ruby
rvm install 2.5.5
rvm use 2.5.5 --default

#Install database requirements
sudo apt-get install postgresql postgresql-contrib libpq-dev
echo -e "CREATE USER samfundet WITH PASSWORD 'samfundet';\nALTER USER samfundet CREATEDB;" | sudo -u postgres psql

#Install the bundler
rvm use 2.5.5 --default
gem install bundler:1.17.3

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
bundle exec rails db:setup

#Run the server
make run
