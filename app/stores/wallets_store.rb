# frozen_string_literal: true

# Store ::Remote info filesystem
#
class WalletsStore < FileSystemStore
  WalletNotFound = Class.new StandardError

  def save!(wallet)
    wallet_dir = build_wallet_dir wallet.id
    FileUtils.mkdir_p wallet_dir unless Dir.exist? wallet_dir
    IO.write wallet_dir.join('body'), wallet.body
  end

  def wallet_size(id)
    File.size build_wallet_dir(id).join('body')
  end

  def find!(id)
    find(id) || raise(WalletNotFound, id)
  end

  def find(id)
    wallet_dir = build_wallet_dir id
    return unless Dir.exist? wallet_dir

    Wallet.new(
      id: id,
      body: IO.read(build_wallet_dir(id).join('body'))
    )
  end

  private

  def build_wallet_dir(id)
    Wallet.validate_id! id
    dir.join id
  end
end
