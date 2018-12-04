# frozen_string_literal: true
require 'psych'

# Store ::Remote info filesystem
#
class RemotesStore
  include AutoLogger

  LINE_SPLITTER = "\n"

  def initialize(file: nil)
    @file = file || raise('Must be a file path')
  end

  def remotes(force = false)
    RequestStore.store[:remotes] if force
    RequestStore.store[:remotes] ||= build_remotes
  end

  # @param [Remote] or [Remotes]
  #
  def add(one_or_more)
    lock! do
      remotes = restore
      Array(one_or_more).each do |remote|
        if remotes.include? remote
          logger.debug "Can't add #{remote} it is already added"
        else
          logger.info "Add #{remote}"
          remotes = remotes << remote
        end
      end
      store remotes
      RequestStore.store[:remotes] = remotes
    end
  end

  private

  attr_reader :file

  def restore
    parse(read).freeze
  end

  def store(remotes)
    lock! do
      IO.write file, remotes.to_yaml
    end

    remotes
  end

  def lock!(&block)
    Zoldy.lock_manager.lock! self.class.name, Settings.lock_timeout, &block
  rescue => err
    logger.error err.message
    raise err
  end

  def read
    YAML.load_file file
  rescue Errno::ENOENT
    []
  end

  def parse(list)
    Remotes.new list.map { |r| Remote.new r }
  end

  def build_remotes
    restore.presence ||
      store(default_remotes)
  end

  def default_remotes
    Remotes.new(
      Settings.default_remotes.map { |r| Remote.parse r }
    )
  end
end
