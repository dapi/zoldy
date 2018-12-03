# frozen_string_literal: true

module Zoldy
  class Middleware
    PROTOCOL = 2

    # HTTP header we add to each HTTP request, in order to inform
    # the other node about the score. If the score is big enough,
    # the remote node will add us to its list of remote nodes.
    SCORE_HEADER = 'X-Zold-Score'

    # HTTP header we add, in order to inform the node about our
    # version. This is done mostly in order to let the other node
    # reboot itself, if the version is higher.
    VERSION_HEADER = 'X-Zold-Version'

    # HTTP header we add, in order to inform the node about our
    # network. This is done in order to isolate test networks from
    # production one.
    NETWORK_HEADER = 'X-Zold-Network'

    # HTTP header we add, in order to inform the node about our
    # protocol.
    PROTOCOL_HEADER = 'X-Zold-Protocol'

    HEADERS = [SCORE_HEADER, VERSION_HEADER, NETWORK_HEADER, PROTOCOL_HEADER]

    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)

      headers['Cache-Control']               = 'no-cache'
      headers['Access-Control-Allow-Origin'] = '*'

      add_zold_headers headers

      [status, headers, body]
    end

    private

    def add_zold_headers headers
      headers[NETWORK_HEADER]         = Settings.network
      headers[VERSION_HEADER]         = Zoldy::VERSION.to_s
      headers[PROTOCOL_HEADER]        = PROTOCOL.to_s
      headers[SCORE_HEADER]           = Zoldy.app.score.to_s
    end
  end
end
