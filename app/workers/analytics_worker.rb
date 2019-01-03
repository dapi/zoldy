# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Runs every minute and perform async ping all remote nodes
#
class AnalyticsWorker
  include Sidekiq::Worker
  include AutoLogger

  def perform
    File.write dir.join(Time.now.utc.iso8601 + '.csv'), Commands::ShowRemotes.new.build_remotes.map(&:to_csv).join
  end

  private

  def dir
    d = Zoldy.app.stores_dir.join('analytics').join('remotes')
    FileUtils.mkdir_p d
    d
  end
end
