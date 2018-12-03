# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.4.5'

# Needed for zold-score
gem 'openssl'
gem 'zold-score'

gem "hiredis", "~> 0.6.0"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0", :require => ["redis", "redis/connection/hiredis"]
gem 'redis-namespace'
gem 'typhoeus'
gem 'semver2'

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

gem 'activesupport'
gem 'actionpack'
gem 'settingslogic'

gem 'rack'
gem 'rake'

gem 'puma'
gem 'auto_logger', '~> 0.1.3'

group :development do
  gem 'guard'
  gem 'guard-foreman'
  gem 'guard-bundler'
  gem 'guard-ctags-bundler'
  gem 'guard-rack'
  gem 'guard-rspec'
  gem 'rubocop'
end

group :development, :test do
  #
end

group :test do
  gem 'factory_bot'
  gem 'rack-test'
  gem 'rspec'
end
