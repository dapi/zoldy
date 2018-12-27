# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Protocol that describes a White Paper
# Think about it like a transalation of WhitePaper from English to Ruby.
#
class Protocol
  include AutoLogger
  include HttpHeaders
  include DataFormats

  VERSION = 2 # Protocol version number

  DATA_CONTENT_TYPE = 'application/json'
  TEXT_CONTENT_TYPE = 'text/plain'

  MIN_SCORE_VALUE = Zold::Score::STRENGTH

  Error = Class.new StandardError

  # Add remote node from the score received in HTTP header
  #
  def touch_remote_by_score_header(remote)
    return if remote.node_alias == Settings.node_alias

    Zoldy.app.remotes_store.add remote
  end

  # @param [Hash] of HTTP request headers
  def add_request_headers(headers)
    # NOTE was reducing to 4
    add_http_headers headers, reduce: 16
  end

  # @param [Hash] of HTTP response headers
  def add_response_headers(headers)
    add_http_headers headers, reduce: 16
  end

  private

  def add_http_headers(headers, reduce:)
    headers[PROTOCOL_HEADER] = VERSION.to_s
    headers[VERSION_HEADER]  = Zoldy.version
    headers[NETWORK_HEADER]  = Settings.network
    headers[SCORE_HEADER]    = Zoldy.app.scores_store.best.try(:reduced, reduce).to_s
    headers
  end
end
