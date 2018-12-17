# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Ping all remote nodes
#
class ReconnectWorker
  include Sidekiq::Worker
  include AutoLogger

  sidekiq_options queue: :critical

  def perform
    Zoldy.app.remotes_store.each do |remote|
      PingWorker.perform_async remote.node_alias
    end.count
  end
end
