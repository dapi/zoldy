require 'sidekiq'

Sidekiq.configure_server do |config|
  config.redis = Settings.sidekiq_redis.symbolize_keys
  config.error_handlers << proc do |ex, context|
    Bugsnag.notify ex do |b|
      b.meta_data = context
    end
  end if defined? Bugsnag
end

Sidekiq.configure_client do |config|
  config.redis = Settings.sidekiq_redis.symbolize_keys
end

crontab_file = File.expand_path('../crontab.yml', __dir__)

Sidekiq::Cron::Job.load_from_hash YAML.load_file crontab_file
