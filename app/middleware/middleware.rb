# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'action_dispatch'

# rubocop:disable
# Middleware pay attention and validate request HTTP headers and
# add response HTTP headers
#
class Middleware
  def initialize(app)
    @app = app
  end

  def call(env)
    parse_zold_headers env
    status, response_headers, body = @app.call(env)
    Zoldy.protocol.add_response_headers response_headers
    [status, response_headers, body]
  end

  private

  def parse_zold_headers(env)
    request_headers = ActionDispatch::Http::Headers.from_hash env

    return unless request_headers[Protocol::NETWORK_HEADER] == Settings.network
    return unless request_headers[Protocol::PROTOCOL_HEADER].to_i == Protocol::VERSION

    score_header = request_headers[Protocol::SCORE_HEADER]

    setup_zold_env env, Zold::Score.load(score_header) if score_header.present?
  end

  def setup_zold_env(env, score)
    return unless score.valid? && score.strength >= Zold::Score::STRENGTH

    env[:zold_score] = score
    env[:zold_remote] = Remote.build_from_score score

    Zoldy.protocol.touch_remote_by_score_header env[:zold_remote]
  end
end
