# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

module Commands
  # Show private wallets list
  #
  class ShowPrivateWallets < Base
    def perform
      print_formatted wallets, headings: ['ID', 'Amount', 'Transactions', 'Has private key?']
    end

    private

    def wallets
      Zoldy.app.private_wallets_store.all.map { |w| [w.id, w.zolds, w.transactions.count, w.valid_private_key?] }
    end
  end
end
