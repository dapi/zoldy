# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

require 'benchmark'

module Commands
  # Fetch selected wallet from alive remote nodes
  #
  class FetchWallet < Base
    def perform(wallet_id)
      results = Zoldy.app.remotes_store.alive.map do |remote|
        fetch_wallet remote, wallet_id
      end

      print_formatted results, headings: [['Remote node', 'Timeout']]
    end

    private

    def fetch_wallet(remote, wallet_id)
      wallet = nil
      bm = Benchmark.measure do
        wallet = remote.client.fetch_wallet wallet_id
      end

      [remote.node_alias, bm.total]
    rescue ZoldClient::Error => err
      [remote.node_alias, err.class]
    end
  end
end
