# frozen_string_literal: true

module DataFormats
  NETWORK_NAME               = /[a-z]{4,16}/.freeze
  WALLET_ID_FORMAT           = /[a-z0-9]{16}/.freeze
  TRANSACTION_DETAILS_FORMAT = /[a-zA-Z0-9 -.]{1,512}/.freeze
end
