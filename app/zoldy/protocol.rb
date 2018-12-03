module Zoldy
  class Protocol
    include AutoLogger

    Error = Class.new StandardError

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
  end
end
