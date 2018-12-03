# frozen_string_literal: true

require File.expand_path('config/environment', __dir__)

require 'sidekiq/web'
require 'sidekiq/cron/web'

Sidekiq::Web.set :session_secret, Settings.secret_key_base

use Rack::Runtime
use Rack::Deflater
use Rack::Reloader
use RequestStore::Middleware
use Middleware

run Rack::URLMap.new('/' => RootAPI, '/sidekiq' => Sidekiq::Web)
