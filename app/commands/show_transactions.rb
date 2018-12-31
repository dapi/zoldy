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

      # 1. id : Transaction ID, an unsigned 16-bit integer, 4-symbols hex; 9
      # 2. time : date and time, in ISO 8601 format, 20 symbols;
      # 3. amount : Zents, a signed 64-bit integer, 16-symbols hex;
      # 4. prefix : Payment prefix, 8-32 symbols;
      # 5. bnf : Wallet ID of the beneficiary, 16-symbols hex;
      # 6. details : Arbitrary text, matching /[a-zA-Z0-9 -.]{1,512}/ ;
      # 7. signature : RSA signature, 684 symbols in Base64.
      print_formatted wallet_transactions(wallet),
                      headings: %w[ID Time Amount Beneficiary Details]
    end

    private

    def wallet_transactions(wallet)
      wallet.transactions.map do |txn|
        [txn.id, txn.time, txn.zolds, txn.bnf, txn.details]
      end
    end
  end
end
