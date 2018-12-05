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

  def save(wallet)
    path = build_wallet_path wallet.id
    store path, wallet.body
  end

  def find!(id)
    find(id) || raise(WalletNotFound, id)
  end

  def find(id)
    path = build_wallet_path id
    return unless File.exist? path

    build id, read(path)
  end

  private

  attr_reader :dir

  def store(file, body)
    IO.write file, body
  end

  def build(id, body)
    Wallet.new id: id, body: body
  end

  def read
    IO.read file
  rescue Errno::ENOENT
    ''
  end

  def build_wallet_path(id)
    Wallet.validate_id! id
    File.expand_path File.join dir, id
  end
end
