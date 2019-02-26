# [Samfundet.no](http://samfundet.no)
![](http://i.imgur.com/8n5hDoC.png)

## Contributing

### Bug Reports and Feature Requests

Use the [issue tracker](https://github.com/Samfundet/Samfundet/issues) to report any bugs or request features.

### Developing

PRs are welcome. Follow these steps to set the website up locally:
#### Ubuntu

1. Install [RVM](https://rvm.io/)
2. Install Ruby 2.3.3 via RVM using the following command
```
source ~/.rvm/scripts/rvm
rvm install 2.3.3 && rvm use 2.3.3 --default
```
3. Choose a database password by running
```echo 'export SAMFDB_DEV_PASS="enteryourpasswordhere"' >> ~/.bashrc && source ~/.bashrc```
4. Database setup
  - Option 1 (requires [Docker CE](https://docs.docker.com/install/linux/docker-ce/ubuntu/) & [docker-compose](https://docs.docker.com/compose/install/))
    1. Start the database: `docker-compose up -d`
    2. Install Postgres dependency `sudo apt-get install libpq-dev`
  - Option 2
    1. Install Postgres:```sudo apt-get install postgresql postgresql-contrib libpq-dev```
    2. `echo -e "CREATE USER samf WITH PASSWORD '$SAMFDB_DEV_PASS';\nALTER USER samf CREATEDB;" | sudo -u postgres psql`
5. Run `bundle install` to install the required Ruby gems
6. Set up the database by running (_each line is a separate command!_):
```
make copy-config-files
sed -i "s/password:.*/password: $SAMFDB_DEV_PASS/" config/database.yml
rake db:setup
```
7. Start the Rails server by running `rails server`.

## License

MIT © Samfundet.no project authors
