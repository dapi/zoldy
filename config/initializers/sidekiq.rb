# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'sidekiq'

Sidekiq.options[:poll_interval] = 15

Sidekiq.configure_server do |config|
  config.redis = Settings.sidekiq_redis.symbolize_keys
  if defined? Bugsnag
    config.error_handlers << proc do |ex, context|
      Bugsnag.notify ex do |b|
        b.meta_data = context
      end
    end
  end

  # Clean unique sidekiq digests
  #
  SidekiqUniqueJobs::Digests.all.each { |digest| SidekiqUniqueJobs::Digests.del digest: digest }

  SidekiqCronSetuper.setup config_file: File.expand_path('../crontab.yml', __dir__)
end

Sidekiq.configure_client do |config|
  config.redis = Settings.sidekiq_redis.symbolize_keys
end
