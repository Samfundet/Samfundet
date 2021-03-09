sudo apt-get update
sudo apt-get upgrade
source ~/.rvmrc
rvm user gemsets
rvm install ruby
rvm install 2.5.5
rvm use 2.5.5 --default
sudo apt-get install postgresql postgresql-contrib libpq-dev
echo -e "CREATE USER samfundet WITH PASSWORD 'samfundet';\nALTER USER samfundet CREATEDB;" | sudo -u postgres psql
rvm reinstall 2.5.5
bundle install

if [ ! -e $CONFIG_DIR/database.yml ] &&
   [ ! -e $CONFIG_DIR/local_env.yml ] &&
   [ ! -e $CONFIG_DIR/billig.yml ] &&
   [ ! -e $CONFIG_DIR/secrets.yml ]; then
     make copy-config-files || exit
fi

bundle exec rails db:setup

make run
