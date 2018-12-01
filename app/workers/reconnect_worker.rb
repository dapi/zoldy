# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'benchmark'

# Ping all remote nodes, get remote nodes list and save it
#
# TODO validate node and remove from list if it's invalid
#
class ReconnectWorker
  include Sidekiq::Worker
  include AutoLogger

  def perform
    Zoldy.app.remotes_store.each do |remote|
      ping_remote remote unless remote.node_alias == Settings.node_alias
    end.count
  end

  private

  def ping_remote(remote)
    bm = Benchmark.measure do
      Zoldy.app.remotes_store.add remote.client.remotes
    end
    logger.info "Successful ping #{remote} with #{bm.real} secs"
  rescue StandardError => err
    logger.error "Ping #{remote} failed with message: #{err}"
  end
end
