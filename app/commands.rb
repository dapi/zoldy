# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# Top level directives
#
class Commands
  include AutoLogger

  def add_default_remotes
    Settings.default_remotes.each do |node_alias|
      Zoldy.app.remotes_store.add node_alias
    end
  end

  def perform_new_score
    score = Zoldy.app.scores_store.build
    logger.info "Start scoring in #{score.time.utc.iso8601}"
    Zoldy.app.scores_store.save! score
    ScoreWorker.perform_async score.time.to_s
  end

  def perform_best_score
    score = Zoldy.app.scores_store.best
    logger.info "Start scoring in #{score.time.utc.iso8601}"
    ScoreWorker.perform_async score.time.to_s
  end

  # Start async wallet fetching from remote invoices
  #
  def fetch_remote_invoice_wallets
    Zoldy.app.remotes_store.all.each do |r|
      fetch_invoice r
    end
  end

  def fetch_invoice(remote)
    score = remote.client.score
    wallet_id = score.invoice.split('@').last
    WalletFetcher.perform_async wallet_id, remote.node_alias
  rescue ZoldClient::Error => err
    logger.warn "#{err} -> #{remote}"
  rescue StandardError
    logger.error "#{err} -> #{remote}"
  end
end
