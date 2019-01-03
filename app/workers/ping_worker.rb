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
    # TODO: perform async
    Zoldy.app.remotes_store.purge_aged_errors node_alias
    fetch_and_update_score node_alias
  end

  private

  def fetch_and_update_score(node_alias)
    Zoldy.app.remotes_store.update_score node_alias, fetch_score(node_alias)
  rescue ZoldClient::Error => err
    raise err if Zoldy.env.test?

    add_error node_alias, err
    nil
  end

  def fetch_score(node_alias)
    score = nil
    bm = Benchmark.measure { score = ZoldClient.new(node_alias).score }
    logger.info "Successful ping #{node_alias} with #{bm_format bm.real}. Score value is #{score.value} prefixes."
    score
  end

  def add_error(node_alias, err)
    logger.error "Failed #{node_alias} ping with message: #{err.class} #{err.message}"
    Zoldy.app.remotes_store.add_error node_alias, err
  end

  def bm_format(real)
    (real * 1000).to_i.to_s + ' ms'
  end
end
