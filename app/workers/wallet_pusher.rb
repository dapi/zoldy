# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>
# frozen_string_literal: true

# It pushes wallet to the remote node
#
class WalletPusher
  include Sidekiq::Worker
  include AutoLogger

  def perform(wallet_id, node_alias)
    unless Zoldy.app.remotes_store.alive? node_alias
      logger.warn "Ignore dead node #{node_alias}"
      return
    end
    push_wallet wallet_id, node_alias
  rescue ZoldClient::Error => ex
    logger.info "Push #{wallet} (#{wallet.digest}) to #{node_alias} failed with #{ex}"
    Zoldy.app.remotes_store.add_error node_alias, ex
  end

  private

  def push_wallet(wallet_id, node_alias)
    wallet = Zoldy.app.wallets_store.find! wallet_id
    client = ZoldClient.new node_alias
    result = client.push_wallet wallet
    logger.info "Push #{wallet} (#{wallet.digest}) to #{node_alias}: #{result}"
  end
end
