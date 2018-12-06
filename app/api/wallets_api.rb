# frozen_string_literal: true

# Protocol supportes /wallet/* endpoint
#
class WalletsAPI < Grape::API
  include ApiHelpers

  content_type :json, Protocol::DATA_CONTENT_TYPE
  content_type :txt,  Protocol::TEXT_CONTENT_TYPE

  default_format :json
  formatter :json, PrettyJSONFormatter

  desc 'Return remotes list'
  resource :wallet do
    resource ':id' do
      get do
        wallet = Zoldy.app.wallets_store.find!(params[:id])
        zold_present body: wallet.body
      end

      desc 'Return transactions count of the wallet'
      get :size do
        content_type Protocol::TEXT_CONTENT_TYPE
        Zoldy.app.wallets_store.wallet_size params[:id]
      end

      put do
        wallet = Wallet.new(id: params[:id], body: request.body.read)
        Zoldy.app.wallets_store.save! wallet

        content_type Protocol::TEXT_CONTENT_TYPE
        status 304

        wallet.body.length
      end
    end
  end
end
