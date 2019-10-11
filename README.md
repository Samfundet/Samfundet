# [Samfundet.no](http://samfundet.no)
![](http://i.imgur.com/8n5hDoC.png)

## Contributing

### Bug Reports and Feature Requests

Use the [issue tracker](https://github.com/Samfundet/Samfundet/issues) to report any bugs or request features.

### Developing

PRs are welcome. Follow these steps to set the website up locally:
#### Ubuntu

1. Install [RVM](https://rvm.io/)
2. Install Ruby 2.5.5 via RVM using the following command
```
source ~/.rvm/scripts/rvm
rvm install 2.5.5 && rvm use 2.5.5 --default
```
3. Choose a database password by running
```echo 'export SAMFDB_DEV_PASS="enteryourpasswordhere"' >> ~/.bashrc && source ~/.bashrc```
4. Database setup
  - Option 1 (requires [Docker CE](https://docs.docker.com/install/linux/docker-ce/ubuntu/) & [docker-compose](https://docs.docker.com/compose/install/))
    1. Start the database: `docker-compose up -d`
    2. Install Postgres dependency `sudo apt-get install libpq-dev`
  - Option 2
    1. Install Postgres:```sudo apt-get install postgresql postgresql-contrib libpq-dev```
    2. `echo -e "CREATE USER samfundet WITH PASSWORD '$SAMFDB_DEV_PASS';\nALTER USER samfundet CREATEDB;" | sudo -u postgres psql`
5. Run `bundle install` to install the required Ruby gems
6. Set up the database by running (_each line is a separate command!_):
```
make copy-config-files
sed -i "s/password:.*/password: $SAMFDB_DEV_PASS/" config/database.yml
bundle exec rails db:setup
```
7. Start the Rails server by running `rails server`.

### Mac

1. Install [RVM](https://rvm.io/) and [Homebrew](https://brew.sh/) with 
```
\curl -sSL https://get.rvm.io | bash -s stable --rails &&
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

2. Set default Rails version to v.2.5.5
```
rvm install 2.5.5 && rvm use 2.5.5 --default
```

3. Choose a database password by running
```
echo 'export SAMFDB_DEV_PASS="samfundet"' >> ~/.bashrc && source ~/.bashrc
```

4. Install [Docker](https://docs.docker.com/docker-for-mac/install/#install-and-run-docker-desktop-for-mac)
```
brew cask install docker
```

5. Start the docker program (you can do that by using Spotlight search) and run
```
docker-compose up -d
```

6. Install postgres dependency
```
brew install postgresql
```

7. Install correct version of libv8 
```
gem install libv8 -v 3.16.14.15 -- --with-system-v8
```

8. Install the required Ruby Gems with 
```
bundle install
```

9. Set up the database by running (_each line is a separate command!_):
```
make copy-config-files
brew install imagemagick
bin/rails db:environment:set RAILS_ENV=development && bundle exec rake db:setup
```

10. Start the Rails server by running `rails server`


#### Add git hooks

You can optionally add checks before commits etc. through git-hooks. To apply them run
```
make git-hooks
```
This will add symbolic links in .git/hooks from the hooks dir.

### Workflow

Make sure that you read the [workflow](docs/github_workflow.md) we have outlined before contributing.

## License

MIT © Samfundet.no project authors
