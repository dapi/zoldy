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
    file = Zoldy.app.stores_dir.join 'version.lock'
    raise 'Zoldy already configured' if File.exist? file

    IO.write file, Zoldy.version
  end

  def start_score_farms
    Sidekiq::ScheduledSet.new.clear
    ScoresWatchDog.perform_async
  end
end
