# [Samfundet.no](http://samfundet.no)

![samfundet-screenshot](http://i.imgur.com/8n5hDoC.png)

[![Build Status](https://travis-ci.org/Samfundet/Samfundet.svg?branch=master)](https://travis-ci.org/Samfundet/Samfundet)

## Installation

Follow the steps below in order to setup our project locally.

> For macOS users: You can try running `make setup-mac` in the root directory. That command will essentially do everything that this `README` tells you do to, but we can't guarantee that it works.

### Clone

Clone our main [repository](https://github.com/Samfundet/Samfundet):

```bash
git clone https://github.com/Samfundet/Samfundet.git
```

We also use two other repositories, [SamfundetAuth](https://github.com/Samfundet/SamfundetAuth) and [SamfundetDomain](https://github.com/Samfundet/SamfundetDomain). These can be cloned with the following commands:

```bash
# SamfundetAuth
git clone https://github.com/Samfundet/SamfundetAuth.git

# SamfundetDomain
git clone https://github.com/Samfundet/SamfundetDomain.git
```

### Dependencies

There are several dependencies needed to get Samfundet up and running. Note that RVM is a Ruby version manager used for handling different Ruby versions, but you can use others as well (like [rbenv](https://github.com/rbenv/rbenv)).

#### macOS

1. [Homebrew](https://brew.sh/): `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`
2. [imagemagick](https://formulae.brew.sh/formula/imagemagick): `brew install imagemagick`
3. [graphviz](https://graphviz.org/): `brew install graphviz`
4. [RVM](https://rvm.io/)

#### Linux

##### Option 1 (Automatic)

1. Go to your terminal preferences, and select your terminal profile. Go to the "Commands" tab and check "Run command as a login shell".
2. Run the following commands:

```bash
chmod +x setup-linux.sh
./setup-linux.sh
```

This will make a script run, that will install a few dependencies for you. A restart is however required after running this script, so restart your computer before proceeding to step 3.

3. After restart, run the following commands:

```bash
chmod +x setup-linux2.sh
./setup-linux2.sh
```

After the script has completed, the project should be up and running!

##### Option 2 (Manual)

1. [graphviz](https://graphviz.org/): `sudo apt-get install graphviz`
2. [imagemagick](https://formulae.brew.sh/formula/imagemagick): `sudo apt-get install imagemagick`
3. [ubuntu_rvm](https://github.com/rvm/ubuntu_rvm)
4. Source RVM: `source ~/.rvm/scripts/rvm`

We now have all dependencies installed, including RVM, so let's install Ruby 2.5.5. Run these two commands in succession:

```bash
rvm install 2.5.5
rvm use 2.5.5 --default
```

### Setup database

We use PostgreSQL as our database. There are several ways it can be installed depending on your operating system.

#### Linux

##### Option 1 (manually)

- Install PostgreSQL: `sudo apt-get install postgresql postgresql-contrib libpq-dev`
- Create the PostgreSQL user: `echo -e "CREATE USER samfundet WITH PASSWORD 'samfundet';\nALTER USER samfundet CREATEDB;" | sudo -u postgres psql`

##### Option 2 (Docker)

1. Install [Docker Engine](https://docs.docker.com/install/linux/docker-ce/ubuntu/) and [Docker Compose](https://docs.docker.com/compose/install/).
2. Start the database: `docker-compose up -d`
3. Install PostgreSQL: `sudo apt-get install libpq-dev`

#### macOS

##### Option 1 (PostgreSQL macOS application)

- Install the [PostgreSQL macOS application](https://postgresapp.com/).

##### Option 2 (Docker)

1. Install Docker: `brew cask install docker`
2. Start the database: `docker-compose up -d`
3. Install PostgreSQL: `brew install postgresql`

### Ruby dependencies (gems)

Samfundet depends on several Ruby dependencies called gems that are listed in our `Gemfile`. To install these, run

```bash
bundle install # or just 'bundle' or 'bundler'
```

### Configure database

First, there are some configuration files that needs to be copied. Run

```bash
make copy-config-files
```

> Only for Linux users:
>
> ```bash
> sed -i "s/password:.*/password: samfundet/" > config/database.yml
> ```

Then, setup the database with

```bash
bundle exec rails db:setup
```

### Start the development server

You are now ready to start the server. Run

```bash
make run # which executes 'bundle exec rails server'
```

## Git hooks

You can optionally add checks before commits et cetera through `git/hooks`. To apply them run

```bash
make git-hooks
```

This will add symbolic links in .git/hooks from the hooks dir.

## License

MIT © Samfundet.no project authors
