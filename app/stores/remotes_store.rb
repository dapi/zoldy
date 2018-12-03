# Store ::Remote info filesystem
#
class RemotesStore
  include AutoLogger

  LOCK_TIMEOUT = 10_000 # 10 seconds
  LINE_SPLITTER = "\n"

  def initialize(file: nil)
    @file = file || raise('Must be a file path')
  end

  def add(remote)
    Zoldy.lock_manager.lock! self.class.name, LOCK_TIMEOUT do
      remotes = restore
      if remotes.include? remote
        logger.debug "Remote #{remote} already exists in list"
      else
        logger.info "Add #{remote} to list"

        store remotes << remote
      end
    end
  end

  def restore
    (
      parse(read).presence ||
      self.class.new(file: Settings.resources.remotes).restore
    ).freeze
  end

  private

  attr_reader :file

  def store(remotes)
    IO.write file, dump(remotes)
  end

  def read
    IO.read file
  rescue Errno::ENOENT
    ''
  end

  def dump(remotes)
    remotes.map do |r|
      [r.host, r.port.to_s].join ','
    end.join LINE_SPLITTER
  end

  def parse(ms)
    list = ms.split(LINE_SPLITTER).map do |r|
      host, port = r.split(',')
      ::Remote.new(host: host, port: port)
    end

    ::Remotes.new list
  end
end
