setup: install

install:
	bundle install
	yarn install
	yarn build
	bundle exec rails db:create db:migrate assets:precompile

test:
	bundle exec rake test

lint:
	lint_rubocop
	lint_slim

lint_rubocop:
	bundle exec rubocop

lint_slim:
	bundle exec slim-lint

init-env:
	cp .env.example .env

.PHONY: test