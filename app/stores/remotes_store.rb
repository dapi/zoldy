# frozen_string_literal: true

# Store <Remote> into filesystem
#
class RemotesStore < FileSystemStore
  delegate :each, to: :remotes

  # Get remotes <Remotes)
  def remotes
    RequestStore.store[:remotes] ||= restore
  end

  def clear!(force: false)
    super force: force
    RequestStore.store[:remotes] = nil
  end

  def touch(remote)
    add remote
  end

  def nscore
    remotes.map(&:score).inject(&:+) || 0
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
