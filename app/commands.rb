# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# Top level directives
#
class Commands
  include AutoLogger

  def create_wallet!(public_key: nil, private_key: nil) # rubocop:disable Metrics/AbcSize
    public_key ||= Zoldy.app.public_key
    private_key ||= Zoldy.app.private_key

    wallet = Wallet.new(
      id: Wallet.generate_id.to_s, # TODO check new id existence in remote nodes
      public_key: public_key,
      private_key: private_key
    )
    logger.info "Create wallet with ID #{wallet.id}"
    Zoldy.app.wallets_store.save_copy! wallet, Zoldy.app.scores_store.best
    WalletPusher.perform_async wallet.id
    wallet
  end

  def add_default_remotes
    Settings.default_remotes.each do |node_alias|
      Zoldy.app.remotes_store.add node_alias
    end
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
