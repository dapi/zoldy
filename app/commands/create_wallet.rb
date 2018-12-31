# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

module Commands
  # Create wallet on current node and push them to the network
  #
  class CreateWallet < Base
    def perform(public_key: nil, private_key: nil)
      wallet = create_wallet public_key: public_key, private_key: private_key
      print_formatted [['Wallet ID', wallet.id]]
    end

    def create_wallet(public_key: nil, private_key: nil) # rubocop:disable Metrics/AbcSize
      public_key ||= Zoldy.app.public_key
      private_key ||= Zoldy.app.private_key

      wallet = build_wallet public_key: public_key, private_key: private_key

      Zoldy.app.private_wallets_store.add wallet
      Zoldy.app.wallets_store.save_copy! wallet, Zoldy.app.scores_store.best
      WalletPusher.perform_async wallet.id
      wallet
    end

    private

    def build_wallet(private_key:, public_key:)
      wallet = Wallet.new(
        id: Wallet.generate_id.to_s,
        public_key: public_key,
        private_key: private_key
      )
      raise 'created wallet is invalid' unless wallet.valid_private_key?

      wallet
    end
  end
end
