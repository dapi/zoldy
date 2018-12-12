# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# Executes first time tasks
#
class Starter
  def perform
    validate_version!
    start_score_farms
  end

  private

  def validate_version!
    file = Zoldy.app.stores_dir.join 'version'
    unless File.exist? file
      IO.write file, Zoldy.version
      return
    end
    file_version = IO.read file
    raise "Wrong version configured #{file_version} <> #{Zoldy.version}" unless file_version == Zoldy.verison.to_s

    raise 'Zoldy is already configured!'
  end

  def start_score_farms
    Sidekiq::ScheduledSet.new.clear
    ScoresWatchDog.perform_async
  end
end
