# Zoldy

[![Build Status](https://travis-ci.org/dapi/zoldy.svg?branch=master)](https://travis-ci.org/dapi/zoldy)
[![Maintainability](https://api.codeclimate.com/v1/badges/73033467d89b385a9ac2/maintainability)](https://codeclimate.com/github/dapi/zoldy/maintainability)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

Proof Of Concept Zold implementation on Ruby.
Zold is A [Fast Cryptocurrency for Micro Payments](https://papers.zold.io/wp.pdf)

# Motivation

* Deep dig into Zold protocol and validate Zold conceptions viability in real life cases.
* Get rid of a mash of threads in [official zold implementation on ruby](https://github.com/zold-io/zold) and get more stable and easy to hack and support application.
* Validate applicability of some typical in web development solutions and design strategies to build cryptocurrency node.
* Have fun.

[![HAVE
FUN](https://i.ytimg.com/vi/PIb6AZdTr-A/hqdefault.jpg?sqp=-oaymwEjCPYBEIoBSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLD9Q0LmucQLrrJureSYqI-VBIKTnQ)](https://www.youtube.com/watch?v=PIb6AZdTr-A)

# Difference to an official implementation

There are a lot of design patterns and `gems` and few pricipes used to get code better, application stable and development easy:

* `puma` A Ruby/Rack web server built for concurrency with cluster mode.
* `sidekiq` Simple, efficient background processing for Ruby. Both puma and sidekiq fully replaces direct threads usage in core application.
* Wallets/Scores/Remote nodes stores are designed to be free of file-locking or mutex bottlenecks.
* Wide Rack middlewares usage
* `foreman` to manage Procfile-based applications
* `grape` and `swagger` to creating documented interactive REST-like APIs
* One YAML-file settings (`./config/settings.yml`) overridable by environment variables.
* Protocol-based specifiactions described in one module (`./app/protocol.rb`) (Hmm.. not sure)
* [bugsnag](https://www.bugsnag.com) is used for realtime production and development bug tracking
* Interactive console (`./bin/console`) to have better development and usage expirience
* Separated `development`, `production` and `test` environments.
* Use `ActiveSupport::Dependencies.autoload_paths` instead of inplace file requirements.
* `Rack::Reloader` for hot code reloading
* `guard` for best practices with realtime testing
* Respect to `SRP` (Single Responsibilty) and `CQRS` (Command Or Query Separation) principes of software development

# What is done and what to do?

* score generation - DONE
* current node emitting and remote nodes discovery - DONE
* wallets receiving - DONE
* pushing wallets to remote nodes - DONE
* wallet creation - TODO
* hosting bonus and taxes - TODO
* stress tests - TODO

# Installation

## Setup environment

1. Install redis: `sudo apt-get install redis`
2. Install rbenv/rvm (rbenv is preferrable): `https://github.com/rbenv/rbenv`
3. Install required ruby and it's depdencies: `rbenv install; gem instal bundler`
4. Highly recomended to install [direnv](https://direnv.net) to work with environment variables in `.envrc` for
   development

## Setup application

1. `bundle`

# Configuratoin

Look into `./config/settings.yml`

# Start in production mode

> RAKE_ENV=production \
> SIDEKIQ_USERNAME=sidekiq SIDEKIQ_PASSWORD=YOUPASSWORD \
> ZOLD_INVOICE=66Yodh14@1142c2d008235bbe \
> bundle exec foreman start

Where `66Yodh14@1142c2d008235bbe` is your (or my) invoice.

# Web interfaces

* sidekiq - http://localhost:4096/sidekiq
* swagger API doc - http://localhost:4096/swagger

# Development

Start guard to have interactive TDD

> bundle exec guard

# Dependencies

* Redis >=3
* Ruby 2.4/2.5

# ROADMAP

* Improve API - restrict plain/text responses and requestes. Use json only. Probably use an jsonapi

# Author

Danil Pismenny, [@pismenny](https://twitter.com/pismenny) / [@pismenny](http://t.me/pismenny)
