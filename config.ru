# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require File.expand_path('config/environment', __dir__)

use Rack::Runtime
use Rack::Deflater
use Rack::Reloader if Zoldy.env.development? || ENV['RACK_RELOADER']
use Bugsnag::Rack
use Middleware
use MiddlewareLogger
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: %i[get put]
  end
end
require 'rack-swagger-ui'

use Rack::Static,
    urls: ['/javascripts', '/stylesheets', '/fonts', '/images'],
    root: File.join(Rack::Swagger::Ui.root, 'public')

map '/swagger' do
  run Rack::Swagger::Ui::Controller.new
end

if Settings.sidekiq_web.username.present?
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  Sidekiq::Web.set :session_secret, Settings.secret_key_base
  map '/sidekiq' do
    use Rack::Auth::Basic, 'Protected Area' do |username, password|
      # Protect against timing attacks:
      # - See https://codahale.com/a-lesson-in-timing-attacks/
      # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
      # - Use & (do not use &&) so that it doesn't short circuit.
      # - Use digests to stop length information leaking
      Rack::Utils.secure_compare(
        ::Digest::SHA256.hexdigest(username),
        ::Digest::SHA256.hexdigest(Settings.sidekiq_web.username)
      ) &
        Rack::Utils.secure_compare(
          ::Digest::SHA256.hexdigest(password),
          ::Digest::SHA256.hexdigest(Settings.sidekiq_web.password)
        )
    end

    run Sidekiq::Web
  end
else
  puts 'Set SIDEKIQ_USERNAME and SIDEKIQ_PASSWORD environment variables to have access to sidekiq web'
end

run RootAPI
