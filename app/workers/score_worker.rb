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
    lock_timeout: 2.hours,
    unique_across_queues: true,
    unique_across_workers: true,
    lock: :while_executing,
    unique_args: ->(args) { [args.first] }
  )

  def self.unique_args(args)
    [args[0]]
  end

  def perform(time = nil)
    logger.info "Start score generation from #{time || :unspecified} time"
    score = regenerate(find_score(time) || build_score)
    logger.info "Delay perform for #{score.time}"
    self.class.perform_async score.time.to_s
  end

  private

  def build_score
    Zoldy.app.scores_store.best || Zoldy.app.scores_store.build
  end

  def find_score(time)
    return unless time

    time = Time.parse time
    score = Zoldy.app.scores_store.find_by_time(time)
    return score if score.present? && !score.expired? && score.valid?

    remove_score time, score
    nil
  end

  def remove_score(time, score)
    if score.nil?
      logger.warn "Score of #{time} is not found"
      return nil
    end

    logger.warn "Score of #{time} is expired, remove them" if score.expired?
    logger.error "Score of #{time} is invalid!" unless score.valid?
    Zoldy.app.scores_store.remove_by_time(time)
  end

  def regenerate(score)
    bm = Benchmark.measure { score = score.next }
    Zoldy.app.scores_store.save! score
    logger.info "Score of #{score.time} with value #{score.value} generated in #{bm} secs"
    score
  end
end
