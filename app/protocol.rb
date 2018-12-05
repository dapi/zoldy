# frozen_string_literal: true

# Protocol that describes a White Paper
#
class Protocol
  include AutoLogger
  include HttpHeaders
  include DataFormats

  VERSION = 2 # Protocol version number

  DATA_CONTENT_TYPE = 'application/json'.freeze
  TEXT_CONTENT_TYPE = 'text/plain'.freeze

  MIN_SCORE_VALUE = Zold::Score::STRENGTH

  Error = Class.new StandardError

  # Add remote node from the score received in HTTP header
  #
  def touch_remote_by_score_header(score_header)
    # TODO: validate network header and protocol numbers
    return if score_header.blank?

    score = Zold::Score.parse_text score_header
    remote = Remote.build_from_score score

    return if remote.node_alias == Settings.node_alias

    puts "touch remote #{remote}"

    # NOTE What it reasone to raise an error? May be just log warning?
    #
    raise Error, 'The score is invalid' unless score.valid?
    raise Error, 'The score is weak' if score.strength < Zold::Score::STRENGTH

    Zoldy.app.remotes_store.touch remote
  end

  # @param [Hash] of HTTP request headers
  def add_request_headers(headers)
    add_http_headers headers
  end

  # @param [Hash] of HTTP response headers
  def add_response_headers(headers)
    add_http_headers headers
  end

  private

  def add_http_headers(headers)
    headers[PROTOCOL_HEADER] = VERSION.to_s
    headers[VERSION_HEADER]  = Zoldy::VERSION.to_s

    headers[NETWORK_HEADER]  = Settings.network
    headers[SCORE_HEADER]    = ReducedScore.new.fetch

    headers
  end
end
