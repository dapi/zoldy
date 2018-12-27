# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Store <Remote> into filesystem
#
class RemotesStore < FileSystemStore
  include RemotesStoreErrors
  include RemotesStoreScores

  def all
    map { |r| r }
  end

  def each
    children.lazy.each do |remote_dir|
      node_alias = Pathname(remote_dir).basename.to_s
      yield Remote.parse node_alias, get_score(node_alias)
    end
  end

  def map
    children.map do |remote_dir|
      node_alias = Pathname(remote_dir).basename.to_s
      yield Remote.parse node_alias, get_score(node_alias)
    end
  end

  # TODO: Return nodes available in last 10 minutes only
  def alive
    children.map do |remote_dir|
      node_alias = Pathname(remote_dir).basename.to_s
      next unless alive? node_alias

      Remote.parse node_alias, get_score(node_alias)
    end.compact
  end

  # Remove all remotes
  # Used in test environment
  def clear!(force: false)
    super force: force
  end

  def add(node_alias)
    FileUtils.mkdir_p build_remote_dir(node_alias)
  end

  def exist?(node_alias)
    Dir.exist? build_remote_dir node_alias
  end

  def touch(node_alias)
    FileUtils.touch build_remote_dir node_alias
  end

  def add_or_touch(node_alias)
    if exist? node_alias
      touch node_alias
    else
      add node_alias
    end
  end

  def remove(node_alias)
    FileUtils.remove_dir build_remote_dir(node_alias)
  rescue Errno::ENOENT
    nil
  end

  private

  # Enumerable remote directories
  def children
    Pathname.new(dir).children
  end

  def build_remote_dir(node_alias)
    dir.join validate_path! node_alias.to_s.strip
  end
end
