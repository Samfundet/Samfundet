# [Samfundet.no](http://samfundet.no)
![](http://i.imgur.com/8n5hDoC.png)

## Contributing

### Bug Reports and Feature Requests

Use the [issue tracker](https://github.com/Samfundet/Samfundet/issues) to report any bugs or request features.

### Developing

PRs are welcome. Follow these steps to set the website up locally:
#### Ubuntu

1. Install Ruby 2.3.3 via rvm using the following commands (_each line is a separate command!_):
```
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable --ruby=2.3.3
source ~/.rvm/scripts/rvm
```
2. Install Postgres:```sudo apt-get install postgresql postgresql-contrib libpq-dev```
3. Run `bundle install` to install the required Ruby gems
4. Choose a database password by running `export SAMFDB_DEV_PASS="enteryourpasswordhere"`.
5. Set up the database by running (_each line is a separate command!_):
```
make copy-config-files
sed -i "s/password:.*/password: $SAMFDB_DEV_PASS/" config/database.yml
echo -e "CREATE USER samf WITH PASSWORD '$SAMFDB_DEV_PASS';\nALTER USER samf CREATEDB;" | sudo -u postgres psql
rake db:setup
```
6. Start the Rails server by running `rails server`.

## License

MIT © Samfundet.no project authors
