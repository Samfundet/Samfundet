rvm user gemsets
rvm install ruby
rvm install 2.5.5 --movable
rvm use 2.5.5 --default
sudo apt-get install postgresql postgresql-contrib libpq-dev
echo -e "CREATE USER samfundet WITH PASSWORD 'samfundet';\nALTER USER samfundet CREATEDB;" | sudo -u postgres psql
bundle install

cp config/database.example.yml config/database.yml
cp config/local_env.example.yml config/local_env.yml
cp config/billig.example.yml config/billig.yml
cp config/secrets.example.yml config/secrets.yml

sed -i "s/password:.*/password: samfundet/" > config/database.yml

bundle exec rails db:setup

make run
