# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Protocol supportes /wallet/* endpoint
#
class WalletsAPI < Grape::API
  include ::ApiHelpers

  Error = Class.new StandardError

  content_type :json, Protocol::DATA_CONTENT_TYPE
  content_type :txt,  Protocol::TEXT_CONTENT_TYPE

  default_format :json
  formatter :json, PrettyJSONFormatter

  rescue_from Error do |e|
    error! e, 403
  end

  desc 'Return remotes list'
  resource :wallet do
    resource ':id' do
      get do
        # TODO: If the client provided the pre-calculated MD5 hash of the wallet content in the
        # If-None-Match HTTP header and it matches with the hash of the content the node contains,
        # a 304 HTTP response is returned.
        wallet = Zoldy.app.wallets_store.find!(params[:id])
        zold_present body: wallet.body
      end

      desc 'Return transactions count of the wallet'
      get :size do
        content_type Protocol::TEXT_CONTENT_TYPE
        Zoldy.app.wallets_store.wallet_size params[:id]
      end

      desc 'Return wallet`s balance (UNDOCUMENTED)'
      get :balance do
        content_type Protocol::TEXT_CONTENT_TYPE
        Zoldy.app.wallets_store.find!(params[:id]).zents
      end

      desc 'Save wallet in local store'
      put do
        content_type Protocol::TEXT_CONTENT_TYPE

        wallet = Wallet.load request.body.read
        if Zoldy.app.wallets_store.copy? wallet
          status 304
        else
          Zoldy.app.wallets_store.save_copy! wallet
          status 202
        end
        wallet.body.length.to_s
      end
    end
  end
end
