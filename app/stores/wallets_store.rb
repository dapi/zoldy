# frozen_string_literal: true

# Store ::Remote info filesystem
#
class WalletsStore
  WalletNotFound = Class.new StandardError

  include AutoLogger

  def initialize(dir: nil)
    @dir = dir.is_a?(Pathname) ? dir : Pathname(dir)
    FileUtils.mkdir_p dir unless Dir.exist? dir
  end

  def save!(wallet)
    wallet_dir = build_wallet_dir wallet.id
    FileUtils.mkdir_p wallet_dir unless Dir.exist? wallet_dir
    IO.write wallet_dir.join('body'), wallet.body
  end

  def wallet_size(id)
    File.size build_wallet_dir(id).join('body')
  end

  def count
    Pathname.new(dir).children.count
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

  # Clear all wallets data
  #
  def clear!(force: false)
    raise 'Clear must be forces to use in production' if Zoldy.env.prodiction? && !force

    FileUtils.rm_rf Dir.glob(dir.join('*'))
  end

  private

  attr_reader :dir

  def build_wallet_dir(id)
    Wallet.validate_id! id
    dir.join id
  end
end
