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
    lock_timeout: 4.hours,
    unique_across_queues: true,
    unique_across_workers: true,
    lock: :while_executing,
    unique_args: ->(args) { [args.first] }
  )

  def self.unique_args(args)
    [args[0]]
  end

  def self.perform_new
    score = Zoldy.app.scores_store.build
    Zoldy.logger.info "Start scoring in #{score.time}"
    Zoldy.app.scores_store.save! score
    perform_async score.time.to_s
  end

  def perform(time = nil)
    time = Time.parse time if time.present?
    logger.info "Start score generation from #{time || :unspecified} time"
    score = regenerate(
      Zoldy.app.scores_store.find_by_time(time) ||
      # Zoldy.app.scores_store.best ||
      Zoldy.app.scores_store.build
    )
    logger.info "Delay perform for #{score.time}"
    self.class.perform_async score.time.to_s
  end

  private

  def regenerate(score)
    bm = Benchmark.measure { score = score.next }
    logger.info "Score of #{score.time} with value #{score.value} generated in #{bm.total} secs"
    Zoldy.app.scores_store.save! score
    score
  end
end
