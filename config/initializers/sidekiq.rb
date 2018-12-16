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

  Sidekiq::Cron::Job.destroy_all!
  SidekiqUniqueJobs::Digests.all.each { |digest| SidekiqUniqueJobs::Digests.del digest: digest }

  crontab_file = File.expand_path('../crontab.yml', __dir__)
  result = Sidekiq::Cron::Job.load_from_hash YAML.load_file crontab_file
  puts "Load sidekiq crontab: #{result.presence || 'Success'}"
end

Sidekiq.configure_client do |config|
  config.redis = Settings.sidekiq_redis.symbolize_keys
end
