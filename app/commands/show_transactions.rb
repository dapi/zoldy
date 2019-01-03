# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

module Commands
  # Show wallet's info
  #
  class ShowTransactions < Base
    def perform(id)
      wallet = Zoldy.app.wallets_store.find!(id)
      wallet.private_key = Zoldy.app.private_wallets_store.get_private_key wallet.id

      print_formatted [
        ['Wallet ID', wallet.id],
        ['Amount', wallet.zolds]
      ]

      print_formatted wallet_transactions(wallet),
                      headings: %w[ID Time Amount Beneficiary Details]
    end

    private

    def wallet_transactions(wallet)
      wallet.transactions..map do |txn|
        [txn.id, txn.time, txn.zolds, txn.bnf, txn.details]
      end
    end
  end
end
