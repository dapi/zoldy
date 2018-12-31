# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Store for private wallets
#
class PrivateWalletsStore < FileSystemStore
  def add(wallet)
    IO.write dir.join(wallet.id + '.pem'), wallet.private_key
  end

  def get_private_key(wallet_id)
    file = dir.join(wallet_id + '.pem')
    return unless File.exist? file

    File.read file
  end

  def all
    Dir[dir.join('*.pem')].map do |file|
      load_wallet Pathname(file).basename('.pem').to_s
    end
  end

  private

  def load_wallet(wallet_id)
    wallet = Zoldy.app.wallets_store.find! wallet_id
    wallet.private_key = get_private_key wallet_id
    wallet
  end
end
