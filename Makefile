.PHONY: all
all:
	bundle install
	bundle exec rake db:migrate

.PHONY: run
run:
	bundle exec rails server

.PHONY: copy-config-files
copy-config-files:
	cp config/database.example.yml config/database.yml
	cp config/local_env.example.yml config/local_env.yml
	cp config/billig.example.yml config/billig.yml
	cp config/secrets.example.yml config/secrets.yml

.PHONY: copy-travis-files
copy-travis-files:
	cp config/database.travis.yml config/database.yml

.PHONY: lint
lint:
	bundle exec rubocop -D

.PHONY: format
format:
	bundle exec rubocop -x

.PHONY: test
test:
	rspec .

.PHONY: deploy-production
deploy-production:
	bundle exec mina deploy:production

.PHONY: deploy-staging
deploy-staging:
	bundle exec mina deploy:staging

.PHONY: git-hooks
git-hooks:
	ln -fs hooks/* .git/hooks

localseed:
	RAILS_ENV=development rake db:seed

truncate:
	RAILS_ENV=development rake db:seed:development:truncate

setup-mac:
	sh setup-mac.sh

.PHONY: generate-diagrams
generate-diagrams:
	[ -d docs/diagrams ] ||  mkdir docs/diagrams
	railroady -M | neato -Tsvg > docs/diagrams/models.svg
	railroady -C | neato -Tsvg > docs/diagrams/controllers.svg
