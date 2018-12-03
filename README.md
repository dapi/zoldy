# Zoldy

Brave (unofficial) ZOLD implementation on Ruby

* ZOLD White Paper - https://papers.zold.io/wp.pdf

# Motivation

# Installation

1. Install redis: `sudo apt-get install redis`
2. Install rbenv/rvm (rbenv is preferrable): `https://github.com/rbenv/rbenv`
3. Install required ruby and it's depdencies: `rbenv install; gem instal
   bundled`
4. Install application dependencies: `bundle`

# Deployment

> RAKE_ENV=production bundle exec foreman start

# Settings

Look into `./config/settings.yml`

# Development

I recoment to install `direnv` to work with environment variables in `.envrc`

Start an application:

> bundle exec guard

It starts `sidekiq`, and `rack` application on 4096 (default) port

# Dependencies

* redis
* ruby


# Diffenece with offical version

* `Zoldy::Protocol` - class contains implementation of ZOLD protocol. Think about it like and transalation of WhitePaper from English to Ruby
* Use sidekiq instead of metronome
* Node is common rack-application
* develpoment console a-like `rails c` -> `./bin/console`
* reloads application when code is changes in development
* Uses `foreman` to start and manager processes in development and production

# TODO

* Setup capistrano deployment
* Build docker container with dependencies
