# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Store <Remote> into filesystem
#
class RemotesStore < FileSystemStore
  delegate :each, to: :remotes

  # Get remotes <Remotes)
  def remotes
    restore
  end

  def clear!(force: false)
    super force: force
  end

  def touch(remote)
    add remote
  end

  def nscore
    Dir[dir.join('*/score')].map { |f| File.read(f).to_i }.inject(&:+)
  end

  # @param [Remote] or [Enumerable<Remote>]
  #
  def add(one_or_more)
    Array(one_or_more).map do |remote|
      add_or_update remote
    end
  end

  def update_score(remote, score)
    remote_dir = dir.join validate_path! remote.node_alias
    File.write remote_dir.join('score'), score.to_s
  end

  def get_score(remote)
    remote_dir = dir.join validate_path! remote.node_alias
    File.read(remote_dir.join('score')).to_i
  rescue Errno::ENOENT
    nil
  end

  private

  # @param <Enumerable>
  #
  def add_or_update(remote)
    FileUtils.mkdir_p dir.join validate_path! remote.node_alias
    update_score remote, remote.score if remote.score.present? && remote.score >= Protocol::MIN_SCORE_VALUE
    remote
  end

  def restore
    Pathname.new(dir).children.map do |remote_dir|
      Remote.parse remote_dir.basename.to_s
    end
  end
end
