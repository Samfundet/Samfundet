rvm user gemsets
rvm install ruby
rvm install 2.5.5 --movable
rvm use 2.5.5 --default
sudo apt-get install postgresql postgresql-contrib libpq-dev
echo -e "CREATE USER samfundet WITH PASSWORD 'samfundet';\nALTER USER samfundet CREATEDB;" | sudo -u postgres psql
bundle install

if [ ! -e $CONFIG_DIR/database.yml ] &&
   [ ! -e $CONFIG_DIR/local_env.yml ] &&
   [ ! -e $CONFIG_DIR/billig.yml ] &&
   [ ! -e $CONFIG_DIR/secrets.yml ]; then
     make copy-config-files || exit
fi

rm config/database.yml
cp config/database.example.yml config/database.yml

sed -i "s/password:.*/password: samfundet/" > config/database.yml

bundle exec rails db:setup

make run
