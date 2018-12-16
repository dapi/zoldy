# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# Fetches wallet from specified host.
# Save score of that host in wallet's store.
# Perform async fetching for all beneficiaries of all transacfions in wallet
#
# To start fetching all wallets from the network run:
#
# > WalletFetcher.perform_async
#
class WalletFetcher
  include Sidekiq::Worker
  include AutoLogger

  DEFAULT_WALLET_ID  = '0000000000000000'
  DEFAULT_NODE_ALIAS = 'b2.zold.io'
  sidekiq_options(
    retry: false,
    unique: :until_and_while_executing,
    on_conflict: :log,
    unique_args: ->(args) { args }
  )

  def perform(wallet_id = DEFAULT_WALLET_ID, node_alias = nil)
    return fetch_wallet wallet_id, node_alias if node_alias.present?

    Zoldy.app.remotes_store.alive.each do |remote|
      fetch_async wallet_id, remote.node_alias
    end
  end

  private

  def touches_store
    @touches_store = WalletTouchesStore.new(dir: Zoldy.app.stores_dir.join('scores'))
  end

  def fetch_wallet(wallet_id, node_alias)
    logger.info "Start wallet fetching #{wallet_id} from #{node_alias}"

    wallet = fetch_remote_wallet wallet_id, node_alias
    wallet.transactions.map(&:bnf).uniq.each do |id|
      WalletFetcher.perform_async id
    end
  rescue ZoldClient::NotFound
    logger.warn "Wallet #{wallet_id} is not found on #{node_alias}"
  rescue StandardError => ex
    logger.error "Error while fetching wallet '#{wallet_id}', '#{node_alias}' -> #{ex.class} #{ex}"
    nil
  end

  def fetch_remote_wallet(wallet_id, node_alias)
    touches_store.touch wallet_id, node_alias
    wallet, score = Remote.parse(node_alias).client.fetch_wallet_and_score wallet_id

    Zoldy.app.wallets_store.save_copy! wallet, score

    wallet
  end

  def fetch_async(wallet_id, node_alias)
    unless touches_store.expired? wallet_id, node_alias
      logger.warn "Ignore fetching #{wallet_id} from #{node_alias}"
      return
    end

    logger.debug "Perform async fetching #{wallet_id} from #{node_alias}"
    WalletFetcher.perform_async wallet_id, node_alias
  end
end
