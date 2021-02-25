rvm user gemsets
rvm install ruby
rvm install 2.5.5
rvm use 2.5.5 --default
echo 'export SAMFDB_DEV_PASS="samfundet"' >> ~/.bashrc
source ~/.bashrc
sudo apt-get install postgresql postgresql-contrib libpq-dev
echo -e "CREATE USER samfundet WITH PASSWORD '$SAMFDB_DEV_PASS';\nALTER USER samfundet CREATEDB;" | sudo -u postgres psql
bundle install

if [ ! -e $CONFIG_DIR/database.yml ] &&
   [ ! -e $CONFIG_DIR/local_env.yml ] &&
   [ ! -e $CONFIG_DIR/billig.yml ] &&
   [ ! -e $CONFIG_DIR/secrets.yml ]; then
     make copy-config-files || exit
fi

sed -i "s/password:.*/password: $SAMFDB_DEV_PASS/" > config/database.yml

bundle exec rails db:setup

make run
