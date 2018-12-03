# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.4.5'

# Needed for zold-score
gem 'openssl'
gem 'zold-score'

gem 'hiredis', '~> 0.6.0'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0', require: ['redis', 'redis/connection/hiredis']
gem 'redis-namespace'
gem 'semver2'
gem 'typhoeus'

gem 'redlock'

gem 'request_store'
gem 'request_store-sidekiq'

gem 'foreman'

gem 'sidekiq'
gem 'sidekiq-cron'

gem 'bootsnap'

gem 'virtus'

gem 'get_process_mem'
gem 'usagewatch_ext'

gem 'pry'

gem 'grape'
gem 'grape-swagger'

gem 'actionpack'
gem 'activesupport'
gem 'settingslogic'

gem 'rack'
gem 'rake'

gem 'auto_logger', '~> 0.1.3'
gem 'puma'

group :development do
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-ctags-bundler'
  gem 'guard-foreman'
  gem 'guard-rack'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rubocop'
  gem 'rubocop-rspec'
end

group :development, :test do
end

group :test do
  gem 'factory_bot'
  gem 'rack-test'
  gem 'rspec'
end
