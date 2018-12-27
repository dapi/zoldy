# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Store <Remote> into filesystem
#
class RemotesStore < FileSystemStore
  include RemotesStoreErrors
  include RemotesStoreScores

  ALIVE_PERIOD = 15.minutes

  def all
    map { |r| r }
  end

  def each
    children.lazy.each do |remote_dir|
      yield Remote.parse Pathname(remote_dir).basename.to_s
    end
  end

  def map
    children.map do |remote_dir|
      yield Remote.parse Pathname(remote_dir).basename.to_s
    end
  end

  # TODO: Return nodes available in last 10 minutes only
  def alive
    children.map do |remote_dir|
      node_alias = Pathname(remote_dir).basename.to_s
      Remote.parse node_alias if alive? node_alias
    end.compact
  end

  def alive?(node_alias)
    time = last_error_time node_alias
    time.nil? || time < Time.now - ALIVE_PERIOD
  end

  # Remove all remotes
  # Used in test environment
  def clear!(force: false)
    super force: force
  end

  def add(node_alias)
    FileUtils.mkdir_p build_remote_dir(node_alias)
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
