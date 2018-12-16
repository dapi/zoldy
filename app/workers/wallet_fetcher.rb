# Fetches wallet from specified host.
# Save score of that host in wallet's store.
# Perform async fetching for all beneficiaries of all transacfions in wallet
#
# To start fetching all wallets from the network run:
#
# > WalletFetcher.new.perform
#
class WalletFetcher
  include Sidekiq::Worker
  include AutoLogger

  DEFAULT_WALLET_ID = '0000000000000000'
  DEFAULT_NODE_ALIAS = 'b2.zold.io'

  sidekiq_options(
    retry: false,
  )
    #lock_timeout: nil,
    #unique_across_queues: true,
    #unique_across_workers: true,
    #lock: :while_executing,
    #on_conflict: :reject,

    #unique_args: ->(args) { args }
  #)


  def perform(wallet_id = DEFAULT_WALLET_ID, node_alias = DEFAULT_NODE_ALIAS)
    logger.info "Start wallet fetching #{wallet_id} from #{node_alias}"

    remote = Remote.parse DEFAULT_NODE_ALIAS
    wallet, score = remote.client.fetch_wallet_and_score wallet_id

    logger.info "Save wallet #{wallet.id} from #{remote}"
    Zoldy.app.wallets_store.save_copy! wallet, score

    wallet.transactions.each do |t|
      logger.info "Perform async fetching #{t.bnf} from #{remote}"
      # TODO fetch from all known remotes
      # WalletFetcher.perform_async t.bnf, remote
    end
  rescue => error
    logger.error "Error white perform fetching wallet #{wallet_id} from #{node_alias} -> #{error.class} #{error}"
  end
end
