# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'bugsnag'

Bugsnag.configure do |config|
  config.app_version = Zoldy::VERSION.to_s
  config.api_key = ENV['BUGSNAG_API_KEY']
  config.notify_release_stages = %w[production development]
  config.send_code = true
  config.send_environment = true
  config.project_root = Zoldy.root
end
