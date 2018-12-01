require 'json'

module Zoldy
  # Scores generator
  #
  class ScoresFarm

    # @param [Zoldy::Entity::Score] score - current (best) score
    #
    def initialize(score: nil)
      @score = score || Zoldy.app.score || Zold::Score.new( host: Settings.host, port: Settings.port, invoice: Settings.invoice )
    end

    def generate(times = 60)
      times.times.map { prev = score; score = score.next; prev.to_s }
    end
  end
end
