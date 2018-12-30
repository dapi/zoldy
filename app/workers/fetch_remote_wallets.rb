# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>
#
# Start async wallet fetching from remote invoices
#
class FetchRemoteWalletsWorker
  include Sidekiq::Worker
  include AutoLogger

  def perform
    Zoldy.app.remotes_store.all.each do |r|
      fetch_invoice r
    end
  end

  private

  def fetch_invoice(remote)
    score = remote.client.score
    wallet_id = score.invoice.split('@').last
    WalletFetcher.perform_async wallet_id, remote.node_alias
  rescue ZoldClient::Error => err
    logger.warn "#{err} -> #{remote}"
  rescue StandardError => err
    raise err if Zoldy.env.test?

    logger.error "#{err} -> #{remote}"
  end
end
