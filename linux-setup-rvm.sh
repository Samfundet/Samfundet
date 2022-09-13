# Check for updates.
sudo apt-get update
sudo apt-get upgrade

RUBY_VERSION=`cat .ruby-version`

# Install ruby.
rvm user gemsets
rvm install ruby

# For the project, we mainly use Ruby 2.7.6.
rvm install RUBY_VERSION # From .ruby-version.
rvm use RUBY_VERSION --default

#Install database requirements
sudo apt-get install postgresql postgresql-contrib libpq-dev
echo -e "CREATE USER samfundet WITH PASSWORD 'samfundet';\nALTER USER samfundet CREATEDB;" | sudo -u postgres psql
