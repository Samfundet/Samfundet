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
