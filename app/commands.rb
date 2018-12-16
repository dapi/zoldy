# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# Top level directives
#
class Commands
  include AutoLogger

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
      score = begin
                r.client.fetch_score
              rescue StandardError
                nil
              end
      next unless score

      wallet_id = score.invoice.split('@').last

      WalletFetcher.perform_async wallet_id, r.node_alias
    end
  end
end
