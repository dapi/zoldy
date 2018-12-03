# frozen_string_literal: true

# HTTP library to connect to remote nodes
#
class HttpClient
  READ_TIMEOUT = 2
  private_constant :READ_TIMEOUT

  # Connect timeout in seconds
  CONNECT_TIMEOUT = 0.8
  private_constant :CONNECT_TIMEOUT

  MIN_SCORE_VALUE = 3
  private_constant :MIN_SCORE_VALUE

  def initialize(root_url, protocol:)
    @root_url = root_url.is_a?(URI) ? root_url : URI(root_url)
    @protocol = protocol
  end

  def get(path, timeout: READ_TIMEOUT)
    Typhoeus::Request.get(
      build_uri(path),
      accept_encoding: 'gzip',
      headers: headers,
      connecttimeout: CONNECT_TIMEOUT,
      timeout: timeout
    )
  end

  def put(path, body, timeout: READ_TIMEOUT)
    Typhoeus::Request.put(
      build_uri(path),
      accept_encoding: 'gzip',
      body: body,
      headers: headers.merge('Content-Type': 'text/plain'),
      connecttimeout: CONNECT_TIMEOUT,
      timeout: timeout
    )
  end

  private

  attr_reader :root_url, :protocol

  def build_uri(_path)
    uri = root_url.clone
    uri.path
    uri
  end

  def headers
    protocol.add_request_headers(
      'User-Agent' => "Zoldy #{Zoldy::VERSION}",
      'Connection' => 'close',
      'Accept-Encoding' => 'gzip'
    )
  end
end
