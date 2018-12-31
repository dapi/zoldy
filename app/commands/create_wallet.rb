# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

module Commands
  # Create wallet on current node and push them to the network
  #
  class CreateWallet < Base
    def perform(public_key: nil, private_key: nil)
      public_key ||= Zoldy.app.public_key
      private_key ||= Zoldy.app.private_key

      wallet = create_wallet public_key: public_key, private_key: private_key
      print_formatted [['Wallet ID', wallet.id]]
    end

    private

    def create_wallet(public_key:, private_key:)
      wallet = Wallet.new(
        id: Wallet.generate_id.to_s, # TODO: check new id existence in remote nodes
        public_key: public_key,
        private_key: private_key
      )
      Zoldy.app.private_wallets_store.add wallet
      Zoldy.app.wallets_store.save_copy! wallet, Zoldy.app.scores_store.best
      WalletPusher.perform_async wallet.id
      wallet
    end
  end
end
