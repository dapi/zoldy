# frozen_string_literal: true

require 'benchmark'

# Calculate current score and queue itself to calculate next score
#
class ScoreFarmWorker
  include Sidekiq::Worker
  include AutoLogger

  LONG_TIME_LIVE_PERIOD = 100.days

  sidekiq_options queue: 'scores_farm'

  # Hack a system and increase your nodes's score
  #
  def self.make_long_time_living_score
    perform_async Zoldy.app.scores_store.build(time: Time.now + LONG_TIME_LIVE_PERIOD).to_s
  end

  def perform(score_serialized = nil)
    score = regenerate(
      parse_score(score_serialized) || build_score
    )
    self.class.perform_async score.to_s
  end

  private

  def build_score
    Zoldy.app.scores_store.best || Zoldy.app.scores_store.build
  end

  def parse_score(score_serialized)
    return unless score_serialized

    score = Zold::Score.parse score_serialized
    return if score.expired? || !score.valid?

    score
  end

  def regenerate(score)
    bm = Benchmark.measure { score = score.next }
    Zoldy.app.scores_store.save! score
    logger.info "Score '#{score.value}' in #{bm.real} secs"
    score
  end
end
