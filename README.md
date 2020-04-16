# [Samfundet.no](http://samfundet.no)

![samfundet-screenshot](http://i.imgur.com/8n5hDoC.png)

[![Build Status](https://travis-ci.org/Samfundet/Samfundet.svg?branch=master)](https://travis-ci.org/Samfundet/Samfundet)

## Contributing

### Bug reports and feature requests

Use the [issue tracker](https://github.com/Samfundet/Samfundet/issues) to report any bugs or feature requests.

## Developing

> Word of caution: If you're using Windows, you should really try to get some distribution of Linux up and running. That way you will *not* be in a world of hurt.

### Setup

PRs are welcome. Follow these steps to set the website up locally:

#### Clone

Clone [Samfundet](https://github.com/Samfundet/Samfundet), our main repository:

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

#### Dependencies

##### macOS: Homebrew and imagemagick

macOS users need [Homebrew](https://brew.sh/), a package manager for macOS. Homebrew can be installed like this:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
```

macOS users *also* need the `imagemagick` dependency, which can be installed through Homebrew:

```bash
brew install imagemagick
```

##### RVM

Samfundet is a [Ruby on Rails](https://rubyonrails.org/) application and as such needs Ruby. It's recommended to use a Ruby version manager to manage different versions of Ruby. For this, we recommened to install RVM (but you can use others as well, for example [rbenv](https://github.com/rbenv/rbenv)). Install RVM through either of these locations:

- Linux: [ubuntu_rvm](https://github.com/rvm/ubuntu_rvm)
- macOS: [RVM](https://rvm.io/)

##### Ruby

We now have RVM installed, so we can install Ruby 2.5.5.

> Only for Linux users:
>
> ```bash
> source ~/.rvm/scripts/rvm
> ```

Run these two commands in succession:

```bash
rvm install 2.5.5
rvm use 2.5.5 --default
```

#### Database

First, we must configure our database password:

```bash
# Replace '.bashrc' with '.zshrc' if you use ZSH
echo 'export SAMFDB_DEV_PASS="<PASSWORD-GOES-HERE>"' >> ~/.bashrc
source ~/.bashrc
```

#### Setup database

We use PostgreSQL as our database. There are several ways it can be installed depending on your operating system.

##### Linux

###### Option 1 (manually)

- Install PostgreSQL: `sudo apt-get install postgresql postgresql-contrib libpq-dev`
- Create PostgreSQL user: `echo -e "CREATE USER samfundet WITH PASSWORD '$SAMFDB_DEV_PASS';\nALTER USER samfundet CREATEDB;" | sudo -u postgres psql`

###### Option 2 (Docker)

1. Install [Docker Engine](https://docs.docker.com/install/linux/docker-ce/ubuntu/) and [Docker Compose](https://docs.docker.com/compose/install/).
2. Start the database: `docker-compose up -d`
3. Install the PostgreSQL dependency: `sudo apt-get install libpq-dev`

##### macOS

###### Option 1 (PostgreSQL macOS application)

- Install the [PostgreSQL macOS application](https://postgresapp.com/).

###### Option 2 (Docker)

1. Install Docker through Homebrew: `brew cask install docker`
2. Start the database: `docker-compose up -d`
3. Install the PostgreSQL dependency: `brew install postgresql`

#### Ruby dependencies (gems)

Samfundet depends on several Ruby dependencies, called gems. To install these, run

```bash
bundle install # or just 'bundle' or 'bundler'
```

#### Configure database

First, there are some configuration files that needs to be copied. Run

```bash
make copy-config-files
```

> Only for Linux users:
>
> ```bash
> sed -i "s/password:.*/password: $SAMFDB_DEV_PASS/" > config/database.yml
> ```

Then, setup the database with

```bash
bundle exec rails db:setup
```

#### Start development server

You are now ready to start the server. Run

```bash
make run # or bundle exec rails server
```

### Git hooks

You can optionally add checks before commits et cetera through `git/hooks`. To apply them run

```bash
make git-hooks
```

This will add symbolic links in .git/hooks from the hooks dir.

## License

MIT © Samfundet.no project authors
