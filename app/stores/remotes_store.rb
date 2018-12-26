# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Store <Remote> into filesystem
#
class RemotesStore < FileSystemStore
  ALIVE_PERIOD = 15.minutes

  def all
    map { |r| r }
  end

  def each
    Pathname.new(dir).children.lazy.each do |remote_dir|
      yield Remote.parse Pathname(remote_dir).basename.to_s
    end
  end

  def map
    Pathname.new(dir).children.map do |remote_dir|
      yield Remote.parse Pathname(remote_dir).basename.to_s
    end
  end

  # TODO: Return nodes available in last 10 minutes only
  def alive
    Pathname.new(dir).children.map do |remote_dir|
      node_alias = Pathname(remote_dir).basename.to_s
      Remote.parse node_alias if alive? node_alias
    end.compact
  end

  def alive?(node_alias)
    time = last_error_time node_alias
    time.nil? || time < Time.now - ALIVE_PERIOD
  end

  # Remote all remotes
  def clear!(force: false)
    super force: force
  end

  def touch(remote)
    add remote
  end

  def add_error(node_alias, err)
    dir = build_remote_dir(node_alias)
    FileUtils.mkdir_p dir
    File.write(
      dir.join(Time.now.utc.iso8601 + '.error'),
      [err.class, err.message].join("\t")
    )
  end

  def nscore
    Dir[dir.join('*/score')].map { |f| File.read(f).to_i }.inject(&:+)
  end

  def add(node_alias)
    FileUtils.mkdir_p build_remote_dir(node_alias)
  end

  def update_score(node_alias, score)
    add node_alias
    File.write build_remote_dir(node_alias).join('score'), score.to_s
  end

  def get_score(remote)
    File.read(build_remote_dir(remote.node_alias).join('score')).to_i
  rescue Errno::ENOENT
    nil
  end

  def get_errors_count(node_alias)
    Dir[build_remote_dir(node_alias).join '*.error'].count
  end

  def last_error_time(node_alias)
    file = Dir[build_remote_dir(node_alias).join '*.error'].max
    return unless file

    File.mtime file
  end

  def remove(node_alias)
    FileUtils.remove_dir build_remote_dir(node_alias)
  rescue Errno::ENOENT
    nil
  end

  private

  def build_remote_dir(node_alias)
    dir.join validate_path! node_alias.to_s.strip
  end
end
