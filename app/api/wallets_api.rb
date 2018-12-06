# frozen_string_literal: true

# Protocol supportes /wallet/* endpoint
#
class WalletsAPI < Grape::API
  helpers do
    include AutoLogger::Named.new(name: :wallets_api)
  end

  content_type :json, Protocol::DATA_CONTENT_TYPE
  content_type :txt,  Protocol::TEXT_CONTENT_TYPE

  default_format :json
  formatter :json, PrettyJSONFormatter

  desc 'Return remotes list'
  resource :wallet do
    resource ':id' do
      helpers do
        def store
          Zoldy.app.wallets_store
        end
      end

      get do
        wallet = store.find!(params[:id])
        zold_present body: wallet.body
      end

      desc 'Return transactions count of the wallet'
      get :size do
        content_type Protocol::TEXT_CONTENT_TYPE
        store.wallet_size params[:id]
      end

      put do
        wallet = Wallet.new(id: params[:id], body: request.body.read)
        logger.info "Save wallet #{wallet.id}"
        Zoldy.app.wallets_store.save! wallet

        content_type Protocol::TEXT_CONTENT_TYPE
        status 304

        wallet.body.length
      end
    end
  end
end
