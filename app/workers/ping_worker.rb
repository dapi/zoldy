# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'benchmark'

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# Ping remote node, save its score or increment errors count
#
class PingWorker
  include Sidekiq::Worker
  include AutoLogger

  # TODO: Clean old errors
  #
  def perform(node_alias)
    return if node_alias == Settings.node_alias

    ping_node node_alias
    Zoldy.app.remotes_store.purge_aged_errors node_alias
  rescue StandardError => err
    logger.error "Failed #{node_alias} ping with message: #{err.class} #{err.message}"
    Zoldy.app.remotes_store.add_error node_alias, err
  end

  private

  def ping_node(node_alias)
    client = ZoldClient.new node_alias
    bm = Benchmark.measure { Zoldy.app.remotes_store.update_score node_alias, client.score }
    logger.info "Successful ping #{node_alias} with #{bm.real} secs"
  end
end
