# frozen_string_literal: true

require 'fileutils'

# Base file system store class.
#
class FileSystemStore
  def initialize(dir: nil)
    @dir = dir.is_a?(Pathname) ? dir : Pathname(dir)
    FileUtils.mkdir_p dir unless Dir.exist? dir
  end

  # Count of records in the store
  def count
    Pathname.new(dir).children.count
  end

  # Clear all wallets data
  #
  def clear!(force: false)
    raise 'Clear must be forces to use in production' if Zoldy.env.prodiction? && !force

    FileUtils.rm_rf Dir.glob(dir.join('*'))
  end

  private

  attr_reader :dir
end
