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
  MAX_ERRORS = 2

  def perform
    Zoldy.app.remotes_store.each do |remote|
      ping_remote remote unless remote.node_alias == Settings.node_alias
    end.count
  end

  private

  def ping_remote(remote)
    bm = Benchmark.measure { Zoldy.app.remotes_store.add remote.client.remotes }
    logger.info "Successful ping #{remote} with #{bm.real} secs"
  rescue StandardError => err
    logger.error "Failed #{remote} ping with message: #{err.class} #{err.message}"
    log_remote_error remote, err
  end

  def log_remote_error(remote, err)
    Zoldy.app.remotes_store.add_error remote, err
    return if Zoldy.app.remotes_store.get_errors_count(remote) < MAX_ERRORS

    logger.info "Remove #{remote}"
    Zoldy.app.remotes_store.remove remote
  end
end
