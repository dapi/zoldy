# frozen_string_literal: true

require 'action_dispatch'

# Middleware pay attention and validate request HTTP headers and
# add response HTTP headers
#
class Middleware
  def initialize(app)
    @app = app
  end

  def call(env)
    Zoldy.protocol.add_remote_by_score_header(
      ActionDispatch::Http::Headers.from_hash(env)[Protocol::SCORE_HEADER]
    )

    status, headers, body = @app.call(env)

    headers['Cache-Control']               = 'no-cache'
    headers['Access-Control-Allow-Origin'] = '*'

    Zoldy.protocol.add_response_headers headers

    [status, headers, body]
  end
end
