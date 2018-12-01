module Zoldy
  class Farm
    def dump
      IO.write scores_file, generate
    end

    def scores
      @scores ||= load
    end

    def load
      IO.read(scores_file).split(/\n/).map do |t|
        Score.parse(t)
      end.compact
    end

    def generate(times = 60)
      score = Zoldy.app.score
      times.times.map { prev = score; score = score.next; prev.to_s }.join("\n")
    end

    private

    def scores_file
      'scores_file'
    end
  end
end
