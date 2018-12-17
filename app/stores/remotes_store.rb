# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Store <Remote> into filesystem
#
class RemotesStore < FileSystemStore
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
    all
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

  def get_errors_count(remote)
    Dir[build_remote_dir(remote.node_alias).join '*.error'].count
  end

  def remove(node_alias)
    FileUtils.remove_dir build_remote_dir(node_alias)
  rescue Errno::ENOENT
    nil
  end

  private

  def build_remote_dir(node_alias)
    dir.join validate_path! node_alias.to_s
  end
end
