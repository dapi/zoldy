# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

module Commands
  # Show wallet's info
  #
  class ShowWallet < Base
    def perform(id)
      wallet = Zoldy.app.wallets_store.find!(id)
      wallet.private_key = Zoldy.app.private_wallets_store.get_private_key wallet.id

      print_formatted [
        ['ID', wallet.id],
        ['Has private key?', wallet.valid_private_key?],
        ['Transactions', wallet.transactions.count],
        ['Amount', wallet.zolds]
      ]
    end
  end
end
