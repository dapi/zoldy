# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>
#
# Stores timestamp of remote wallet's touches
#
class WalletTouchesStore < FileSystemStore
  TOUCH_EXPIRAION_PERIOD = 5.minute

  include WalletsStorePaths

  def touch(wallet_id, node_alias)
    FileUtils.mkdir_p build_wallet_dir(wallet_id)
    FileUtils.touch build_remote_touch_file(wallet_id, node_alias)
  rescue Errno::ENOENT
    nil
  end

  def touched_at(wallet_id, node_alias)
    File.mtime build_remote_touch_file(wallet_id, node_alias)
  rescue Errno::ENOENT
    nil
  end

  def expired?(wallet_id, node_alias)
    Time.now - (touched_at(wallet_id, node_alias) || 0) > TOUCH_EXPIRAION_PERIOD
  end

  private

  def build_remote_touch_file(wallet_id, node_alias)
    build_wallet_dir(wallet_id).join(node_alias + '.remote')
  end
end
