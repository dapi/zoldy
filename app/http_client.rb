class HttpClient
  PROTOCOL = Zoldy::Middleware::PROTOCOL

  READ_TIMEOUT = 2
  private_constant :READ_TIMEOUT

  # Connect timeout in seconds
  CONNECT_TIMEOUT = 0.8
  private_constant :CONNECT_TIMEOUT

  MIN_SCORE_VALUE = 3
  private_constant :MIN_SCORE_VALUE


  def initialize(uri:, score: nil, network: Settings.network)
    @uri = uri.is_a?(URI) ? uri : URI(uri)
    @score = score || Zoldy.app.score
    @network = network
  end

  def get(timeout: READ_TIMEOUT)
    Typhoeus::Request.get(
      uri,
      accept_encoding: 'gzip',
      headers:         headers,
      connecttimeout:  CONNECT_TIMEOUT,
      timeout:         timeout
    )
  end

  def put(body, timeout: READ_TIMEOUT)
    Typhoeus::Request.put(
      uri,
      body:           body,
      headers:        headers.merge('Content-Type': 'text/plain'),
      connecttimeout: CONNECT_TIMEOUT,
      timeout:        timeout
    )
  end

  private

  attr_reader :uri, :score, :network

  def headers
    headers = {
      'User-Agent'      => "Zoldy #{Zoldy::VERSION}",
      'Connection'      => 'close',
      'Accept-Encoding' => 'gzip'
    }
    headers[Zoldy::Middleware::VERSION_HEADER]  = Zoldy::VERSION.to_s
    headers[Zoldy::Middleware::PROTOCOL_HEADER] = PROTOCOL.to_s
    headers[Zoldy::Middleware::NETWORK_HEADER]  = network
    headers[Zoldy::Middleware::SCORE_HEADER]    = score.reduced(4).to_text if score.valid? && !score.expired? && score.value > MIN_SCORE_VALUE
    headers
  end
end
