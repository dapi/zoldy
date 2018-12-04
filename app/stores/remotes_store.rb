# frozen_string_literal: true

# Store ::Remote info filesystem
#
class RemotesStore
  include AutoLogger

  LOCK_TIMEOUT = Zoldy.env.test? ? 100 : 10_000 # 10 seconds
  LINE_SPLITTER = "\n"

  def initialize(file: nil)
    @file = file || raise('Must be a file path')
  end

  def add(remote)
    lock! do
      remotes = restore
      if remotes.include? remote
        logger.debug "Can't add #{remote} it is already added"
      else
        logger.info "Add #{remote}"

        store remotes << remote
      end
    end
  end

  def restore
    parse(read).freeze
  end

  def store(remotes)
    lock! do
      IO.write file, dump(remotes)
    end

    remotes
  end

  private

  attr_reader :file

  def lock!(&block)
    Zoldy.lock_manager.lock! self.class.name, LOCK_TIMEOUT, &block
  end

  def read
    IO.read file
  rescue Errno::ENOENT
    ''
  end

  def dump(remotes)
    remotes.map(&:node_alias).join LINE_SPLITTER
  end

  def parse(string)
    Remotes.new(
      string.split(LINE_SPLITTER).map { |r| Remote.parse r }
    )
  end
end
