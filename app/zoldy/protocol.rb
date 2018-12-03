module Zoldy
  class Protocol
    include AutoLogger
    VERSION = 2

    Error = Class.new StandardError

    # Add remote node from the score received in HTTP header
    #
    def add_remote_by_score_header(score_header)
      return if score_header.blank?

      logger.debug "Try to add remote by header #{score_header}"

      score = Zold::Score.parse_text score_header

      # NOTE What it reasone to raise an error? May be just log warning?
      #
      raise Error, 'The score is invalid' unless score.valid?
      raise Error, 'The score is weak' if score.strength < Zold::Score::STRENGTH

      AddRemoteWorker.perform_async score.to_s
    end

    def add_zold_specific_response_headers(headers)
      # TODO Do it from protocol
      #
      headers[VERSION_HEADER]  = Zoldy::VERSION.to_s
      headers[PROTOCOL_HEADER] = PROTOCOL.to_s
      headers[NETWORK_HEADER]  = network
      headers[SCORE_HEADER]    = score.reduced(4).to_text if score.valid? && !score.expired? && score.value > MIN_SCORE_VALUE

      headers
    end
  end
end
