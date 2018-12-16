# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>
# frozen_string_literal: true

require 'benchmark'

# Calculate current score and queue itself to calculate next score
#
class ScoreWorker
  include Sidekiq::Worker
  include AutoLogger

  sidekiq_options(
    retry: true,
    queue: :scores_farm,
    unique: :until_and_while_executing,
    on_conflict: :log,
    unique_args: ->(args) { args }
  )

  # TODO: Don't start score generation when have only 2 hours to be expired
  #
  def perform(time) # rubocop:disable Metrics/AbcSize
    time = Time.parse time
    logger.info "Start score generation from #{time.utc.iso8601} time"
    score = Zoldy.app.scores_store.save! regenerate find_or_build(time)
    logger.info "Delay perform for #{score.time.utc.iso8601}"
    self.class.perform_async score.time.to_s
  end

  private

  def find_or_build(time)
    Zoldy.app.scores_store.find_by_time(time) ||
      Zoldy.app.scores_store.build
  end

  def regenerate(score)
    bm = Benchmark.measure { score = score.next }
    logger.info "Score of #{score.time.utc.iso8601} with value #{score.value} generated in #{bm.total} secs"
    score
  end
end
