user=$(whoami)
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install graphviz
sudo apt-get install imagemagick
sudo apt-get install nodejs
sudo add-apt-repository universe
sudo apt-get install software-properties-common
sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install rvm
sudo usermod -a -G rvm $user

source ~/.rvmrc
rvm user gemsets
rvm install ruby
rvm install ruby-2.5.5
rvm use 2.5.5 --default
sudo apt-get install postgresql postgresql-contrib libpq-dev
echo -e "CREATE USER samfundet WITH PASSWORD 'samfundet';\nALTER USER samfundet CREATEDB;" | sudo -u postgres psql
rvm reinstall ruby-2.5.5
bundle install

if [ ! -e $CONFIG_DIR/database.yml ] &&
   [ ! -e $CONFIG_DIR/local_env.yml ] &&
   [ ! -e $CONFIG_DIR/billig.yml ] &&
   [ ! -e $CONFIG_DIR/secrets.yml ]; then
     make copy-config-files || exit
fi

bundle exec rails db:setup

make run


