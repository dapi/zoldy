# frozen_string_literal: true

require 'fileutils'
require 'psych'

# Store ::Remote info filesystem
#
class RemotesStore
  include AutoLogger

  LINE_SPLITTER = "\n"

  def initialize(dir:)
    @dir = dir.is_a?(Pathname) ? dir : Pathname(dir)
    FileUtils.mkdir_p dir unless Dir.exist? dir
  end

  # Clear all remotes data
  #
  def clear!(force: false)
    raise 'Clear must be forces to use in production' if Zoldy.env.prodiction? && !force

    FileUtils.rm_rf Dir.glob(dir.join('*'))
    RequestStore.store[:remotes] = nil
  end

  # Get remotes <Remotes)
  def remotes
    RequestStore.store[:remotes] ||= restore
  end

  # @param [Remote] or [Enumerable<Remote>]
  #
  def add(one_or_more)
    added_nodes = Array(one_or_more).map do |remote|
      add_or_update remote
    end
    RequestStore.store[:remotes] ||= remotes + added_nodes
  end

  private

  attr_reader :dir

  # @param <Enumerable>
  #
  def add_or_update(remote)
    remote_dir = dir.join remote.node_alias
    FileUtils.mkdir_p remote_dir

    File.write remote_dir.join('score'), remote.score.to_s

    remote
  end

  def restore
    Pathname.new(dir).children.map do |remote_dir|
      Remote.parse remote_dir.basename.to_s
    end
  end
end
