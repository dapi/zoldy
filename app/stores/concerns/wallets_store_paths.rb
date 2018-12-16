# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>
#
# Directory path builders container
#
module WalletsStorePaths
  private

  def build_wallet_dir(id)
    id = id.id if id.is_a? Wallet
    dir.join validate_path! id
  end

  def build_wallet_copy_dir(wallet)
    build_wallet_dir(wallet.id).join wallet.digest + '.copy'
  end

  def build_best_wallet_dir(id)
    build_wallet_dir(id).join('best')
  end

  def all_best_dir
    dir.join('*').join('best').join('body')
  end
end
