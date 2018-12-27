# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>
#
# Methods to work with saved errors
#
module RemotesStoreErrors
  def add_error(node_alias, err)
    dir = build_remote_dir(node_alias)
    FileUtils.mkdir_p dir
    File.write(
      dir.join(Time.now.utc.iso8601 + '.error'),
      [err.class, err.message].join("\t")
    )
  end

  def purge_aged_errors(node_alias)
    dir = build_remote_dir(node_alias)
    return unless Dir.exist? dir

    Dir[dir.join('*.error')].count
  end

  def get_errors_count(node_alias)
    Dir[build_remote_dir(node_alias).join '*.error'].count
  end

  def last_error_time(node_alias)
    file = Dir[build_remote_dir(node_alias).join '*.error'].max
    return unless file

    File.mtime file
  end
end
