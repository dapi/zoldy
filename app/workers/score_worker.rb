# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>
# frozen_string_literal: true

require 'benchmark'

# Calculate current score and queue itself to calculate next score
#
class ScoreWorker
  include Sidekiq::Worker
  include AutoLogger

  # Don't waste cpu time and don't calculate score more then needed
  MAX_VALUE = Zold::Score::STRENGTH * 2

  sidekiq_options(
    queue: :scores,
    retry: true,
    unique: :until_and_while_executing
  )

  def perform # rubocop:disable Metrics/AbcSize
    score = find_last_or_build_score
    logger.info "Start score at #{score.time.utc.iso8601}"
    score = Zoldy.app.scores_store.save! regenerate score
    logger.info "Delay perform for #{score.time.utc.iso8601}"
    self.class.perform_async
  end

  private

  def find_last_or_build_score
    score = Zoldy.app.scores_store.last
    return score if score.present? && score.value < MAX_VALUE && !score.expired?

    Zoldy.app.scores_store.build
  end

  def regenerate(score)
    bm = Benchmark.measure { score = score.next }
    logger.info "Score of #{score.time.utc.iso8601} with value #{score.value} generated in #{bm.total} secs"
    score
  end
end
