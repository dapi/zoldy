# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.4.5'

# Needed for zold-score
gem 'openssl'
gem 'zold-score'

gem "hiredis", "~> 0.6.0"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0", :require => ["redis", "redis/connection/hiredis"]
#gem 'redis-namespace'
#gem 'redis-rails'
#gem 'redlock'

gem 'semver2'

gem 'bootsnap'

gem 'get_process_mem'
gem 'usagewatch_ext'

gem 'pry'

gem 'grape'
gem 'grape-swagger'

gem 'activesupport'
gem 'settingslogic'

gem 'rack'
gem 'rake'

gem 'puma'

group :development do
  gem 'guard'
  gem 'guard-bundler'
  gem 'guard-ctags-bundler'
  gem 'guard-rack'
  gem 'rubocop'
end

group :test do
  gem 'rack-test'
end
