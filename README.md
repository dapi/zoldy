# Zoldy

Brave, exrepimental unofficial implementation of Zold on Ruby. Zold is A Fast Cryptocurrency
for Micro Payments.

Zold White Paper is https://papers.zold.io/wp.pdf

# Motivation

* Validate architectural hypothesis of cryptocurrency implementation on Ruby.
* Get a simple and stable Zold server and client thas ease to maintain, disturb
  and support.

## Diffenece between an offical repo

* Used best time-tested Ruby practices instead of unstable custom solutions
* Get rid of a mash of threads spaghetti in code and test.
* Use redis as locking and data storage server.
* Use queue and production-tested `sidekiq` as simple, efficient background processing instead of custom uncontrolled threads running.
* Node server is a common rack-application
* API written on grape with swagger documentation support
* Develpoment console a-like `rails c` -> `./bin/console`
* Uses `foreman` to start and manager processes in development and production
* Reloads application when code is changes in development
* All protocol-bases (White Paper described) operations conatined in one file called a `Protocol`. Think about it like a transalation of WhitePaper from English to Ruby.
* Less code, more stability, open to suggestions and experiments.
* Use one-time loaded environment (a-la Rails) instead of every file alltime
  requiremenets
* Realtime TDD development with `guard`
* Free of dubious coding styles and rules
* Cluster mode
* No memory leaks
* Separate development, production and test environment
* All settings combined in one file `./config/settings.yml` and overridable by
  environment variables

# Installation

1. Install redis: `sudo apt-get install redis`
2. Install rbenv/rvm (rbenv is preferrable): `https://github.com/rbenv/rbenv`
3. Install required ruby and it's depdencies: `rbenv install; gem instal bundler`
4. Install application dependencies: `bundle`

# Start

> RAKE_ENV=production ZOLD_INVOICE=66Yodh14@1142c2d008235bbe bundle exec foreman start

Where `66Yodh14@1142c2d008235bbe` is your (or my) invoice.

# Settings

Look into `./config/settings.yml`

# Life

Ping neighbors nodes:

> ./bin/console PingRemoteNodesWorker.new.perform

# Development

It is recomend to install `direnv` to work with environment variables in `.envrc`

Start an application (puma rack server on 4096 port and sidekiq workers):

> bundle exec foreman start -f Procfile.dev

Start guard to have interactive TDD and rubocop

> bundle exec guard

# Dependencies

* Redis
* Ruby

# Protocol TODO

* Restrict plain/text responses and requestes. Use only json. Probably use
  jsonapi

# TODO

* Setup capistrano deployment
* Build docker container with dependencies
