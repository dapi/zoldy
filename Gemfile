# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.4.5'

# Needed for zold-score
gem 'openssl', '>= 2.1.2'
gem 'zold-score'

gem 'hiredis', '~> 0.6.0'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0', require: ['redis', 'redis/connection/hiredis']
gem 'redis-namespace'
gem 'semver2'
gem 'typhoeus'

gem 'request_store'
gem 'request_store-sidekiq'

gem 'foreman'

gem 'sidekiq'
gem 'sidekiq-cron'

gem 'bootsnap'

gem 'virtus'

gem 'get_process_mem'
gem 'usagewatch_ext'

# Used for debugging and for console
#
gem 'pry'

gem 'grape', '~> 1.2.2'
gem 'grape-swagger'


gem 'actionpack'
gem 'activesupport'
gem 'settingslogic'

gem 'rack'
gem 'rake'

gem 'auto_logger', '~> 0.1.3'
gem 'logger'
gem 'puma'

group :development do
  gem 'rbtrace'

  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-ctags-bundler'
  gem 'guard-foreman'
  gem 'guard-rack'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'timecop'

  gem 'pry-byebug'

  gem 'grape_logging'
end

group :development, :test do
end

group :test do
  gem 'factory_bot'
  gem 'rack-test'
  gem 'rspec'
end

gem 'bugsnag', '~> 6.9'
