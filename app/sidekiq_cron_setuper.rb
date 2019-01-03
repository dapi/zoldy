# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# Reads config/cron.yml and configure sidekiq scheduling.
#
class SidekiqCronSetuper
  def self.setup(config_file:)
    new(config_file: config_file).setup
  end

  def initialize(config_file:)
    @config_file = config_file
  end

  def setup
    Sidekiq::Cron::Job.destroy_all!

    data = load_data
    data['ReconnectWorker']['cron'] = "*/#{Settings.remote_ping_interval} * * * *"
    result = Sidekiq::Cron::Job.load_from_hash data
    puts "Load sidekiq crontab: #{result.presence || 'Success'}"
  end

  private

  attr_reader :config_file

  def load_data
    YAML.load_file config_file
  end
end
