# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Helpers used in grape API
module ApiHelpers
  extend ActiveSupport::Concern

  included do
    helpers do
      def zold_headers
        headers.slice(*::Protocol::HEADERS)
      end

      def zold_present(hash)
        hash.reverse_merge(
          version: Zoldy.version,
          alias: Settings.node_alias,
          score: Zoldy.app.scores_store.best.to_h,
          wallets: Zoldy.app.wallets_store.count
        )
      end
    end
  end
end
