# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Store <Remote> into filesystem
#
class RemotesStore < FileSystemStore
  delegate :each, to: :remotes

  # Get remotes <Remotes)
  def all
    Pathname.new(dir).children.map do |remote_dir|
      Remote.parse remote_dir.basename.to_s
    end
  end

  def clear!(force: false)
    super force: force
  end

  def touch(remote)
    add remote
  end

  def add_error(remote, err)
    File.write(
      build_remote_dir(remote).join(Time.now.utc.iso8601 + '.error'),
      [err.class, err.message].join("\t")
    )
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
    File.write build_remote_dir(remote).join('score'), score.to_s
  end

  def get_score(remote)
    File.read(build_remote_dir(remote).join('score')).to_i
  rescue Errno::ENOENT
    nil
  end

  def get_errors_count(remote)
    Dir[build_remote_dir(remote).join '*.error'].count
  end

  def remove(remote)
    FileUtils.remove_dir build_remote_dir(remote)
  rescue Errno::ENOENT
    nil
  end

  private

  # @param <Enumerable>
  #
  def add_or_update(remote)
    update_score remote, remote.score if remote.score.present? && remote.score >= Protocol::MIN_SCORE_VALUE
    remote
  end

  def build_remote_dir(remote)
    rd = dir.join validate_path! remote.node_alias
    FileUtils.mkdir_p rd
    rd
  end
end
