# frozen_string_literal: true

require 'benchmark'

# Ping all remote nodes, get remote nodes list and save it
#
# TODO validate node and remove from list if it's invalid
#
class PingRemoteNodesWorker
  include Sidekiq::Worker
  include AutoLogger

  def perform
    Zoldy.app.remotes.each do |remote|
      ping_remote remote
    end.count
  end

  private

  def ping_remote(remote)
    bm = Benchmark.measure do
      Zoldy.app.remotes_store.add remote.client.get_remotes
    end
    logger.info "Successful ping #{remote} with #{bm.real} secs"
  rescue StandardError => err
    logger.error "Ping #{remote} failed with message: #{err}"
  end
end
