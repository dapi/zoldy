module Zoldy
  class Protocol
    Error = Class.new StandardError

    def add_remote_by_score_header(score_header)
      return if score_header.blank?

      score = Zold::Score.parse_text score_header

      raise Error, 'The score is invalid' unless score.valid?
      raise Error, 'The score is weak' if score.strength < Zold::Score::STRENGTH

      AddRemoteWorker.perform_async score.to_s
    end
  end
end
