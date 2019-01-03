# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

module Commands
  # Show wallet's info
  #
  class ShowWallet < Base
    include ConsoleFormats

    TRANSACTIONS_LIMIT = 10

    def perform(wallet_id)
      wallet = load_wallet wallet_id
      show_wallet wallet
      puts
      show_wallet_transactions wallet
    end

    private

    def load_wallet(wallet_id)
      wallet = Zoldy.app.wallets_store.find!(wallet_id)
      wallet.private_key = Zoldy.app.private_wallets_store.get_private_key wallet.id
      wallet
    end

    def show_wallet(wallet)
      print_formatted [
        ['ID', wallet.id],
        ['Has private key?', wallet.valid_private_key?],
        ['Transactions', wallet.transactions.count],
        ['Amount', wallet.zolds]
      ], show_total: false
    end

    def show_wallet_transactions(wallet)
      transactions = wallet_transactions(wallet)
      records = transactions.slice 0, TRANSACTIONS_LIMIT
      puts "Total #{transactions.count} transactions, on this page: #{records.count}. Last on top."
      print_formatted records,
                      headings: %w[ID Time Amount Beneficiary Details],
                      show_total: false
    end

    def wallet_transactions(wallet)
      wallet.transactions.reverse.map do |txn|
        [txn.id, time_format(txn.time), txn.zolds, txn.bnf, txn.details]
      end
    end
  end
end
