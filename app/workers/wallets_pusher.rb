# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>
# frozen_string_literal: true

# It pushes all wallets to the remote node
#
class WalletsPusher
  include Sidekiq::Worker
  include AutoLogger

  def perform(node_alias)
    logger.info "Push all wallets to #{node_alias}"
    Zoldy.app.wallets_store.each do |wallet|
      WalletPusher.perform_async wallet.id, node_alias
    end
  end
end
