# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Root API agregator
#
class RootAPI < Grape::API
  format :json
  default_format :json
  formatter :json, PrettyJSONFormatter

  rescue_from WalletsStore::WalletNotFound do |e|
    error! e, 404
  end

  # Protocol implementation
  #
  mount HomeAPI
  mount RemotesAPI
  mount WalletsAPI

  # Debug and other api's
  mount VersionAPI

  add_swagger_documentation(
    api_version: 'v1',
    doc_version: Zoldy::VERSION.to_s,
    info: {
      title: 'Zoldy API',
      description: 'An Experimental Non-Blockchain Cryptocurrency for Fast Micro Payments'
    },
    # base_path: '/private',
    # add_base_path: true,
  )
end
