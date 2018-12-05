# frozen_string_literal: true

# Remote node description model
#
class Remote
  SPLITTER = ':'

  attr_reader :host, :port, :remotes_count

  delegate :hash, :to_s, to: :node_alias

  delegate :to_yaml, to: :to_h

  def self.build_from_score(score)
    new(
      host: score.host,
      port: score.port,
      score: score.value
    )
  end

  def self.parse(home)
    host, port = home.split SPLITTER
    new host: host, port: port
  end

  def initialize(host:, port:, score: nil, remotes_count: nil)
    @host          = host
    @port          = port.to_i
    @score         = score
    @remotes_count = remotes_count
  end

  def ==(other)
    home == other.home
  end

  def uri
    URI.parse home
  end

  def client
    ZoldClient.new self
  end

  def to_h
    {
      host: host,
      port: port,
      score: score,
      remotes_count: remotes_count
    }
  end

  def home
    'http://' + node_alias
  end

  def node_alias
    [host, port].join SPLITTER
  end

  def errors
    0 # TODO
  end

  def score
    0 # TODO
  end

  def default?
    false # TODO
  end

  def as_json
    {
      host: host,
      port: port,
      score: score,
      errors: errors,
      default: default?,
      home: uri
    }
  end
end
