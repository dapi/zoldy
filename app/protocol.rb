# frozen_string_literal: true

# Protocol that describes a White Paper
#
class Protocol
  include AutoLogger
  include HttpHeaders
  include DataFormats

  VERSION = 2 # Protocol version number

  MIN_SCORE_VALUE = Zold::Score::STRENGTH

  # Reduce publicated score for http headers
  SCORE_REDUCING = 4

  Error = Class.new StandardError

  # Add remote node from the score received in HTTP header
  #
  def add_remote_by_score_header(score_header)
    # TODO: validate network header and protocol numbers
    return if score_header.blank?

    logger.debug "Validate remote by header #{score_header}"

    score = Zold::Score.parse_text score_header

    # NOTE What it reasone to raise an error? May be just log warning?
    #
    raise Error, 'The score is invalid' unless score.valid?
    raise Error, 'The score is weak' if score.strength < Zold::Score::STRENGTH

    Zoldy.app.remotes_store.add Remote.build_from_score score
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
    score = Zoldy.app.score

    headers[PROTOCOL_HEADER] = VERSION.to_s
    headers[VERSION_HEADER]  = Zoldy::VERSION.to_s

    headers[NETWORK_HEADER]  = Settings.network
    headers[SCORE_HEADER]    = score.reduced(SCORE_REDUCING).to_text if score_valid?(score)

    headers
  end

  def score_valid?(score)
    score.valid? && !score.expired? && score.value >= MIN_SCORE_VALUE
  end
end
