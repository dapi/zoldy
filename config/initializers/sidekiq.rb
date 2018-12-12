# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = Settings.sidekiq_redis.symbolize_keys
  if defined? Bugsnag
    config.error_handlers << proc do |ex, context|
      Bugsnag.notify ex do |b|
        b.meta_data = context
      end
    end
  end

  crontab_file = File.expand_path('../crontab.yml', __dir__)
  Sidekiq::Cron::Job.destroy_all!
  Sidekiq::Cron::Job.load_from_hash YAML.load_file crontab_file

  Sidekiq::ScheduledSet.new.clear
  ScoresWatchDog.perform_async
end

Sidekiq.configure_client do |config|
  config.redis = Settings.sidekiq_redis.symbolize_keys
end
