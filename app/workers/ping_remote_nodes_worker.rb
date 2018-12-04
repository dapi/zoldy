# frozen_string_literal: true

require 'benchmark'

# Ping all remote nodes
#
# TODO validate node and remove from list is it is unvalid
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
      remote.ping!
    end
    logger.info "Successful ping #{remote} with #{bm.real} secs"
  rescue StandardError => err
    logger.error "Ping #{remote} failed with message: #{err}"
  end
end
