# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>
# frozen_string_literal: true

require 'benchmark'

# Calculate current score and queue itself to calculate next score
#
class ScoreWorker
  include Sidekiq::Worker
  include AutoLogger

  sidekiq_options retry: true

  def perform(score_serialized = nil)
    logger.info "Start score generation from #{score_serialized || :unspecified}"
    score = regenerate(parse_score(score_serialized) || build_score)
    self.class.perform_async score.to_s
  end

  private

  def build_score
    Zoldy.app.scores_store.best || Zoldy.app.scores_store.build
  end

  def parse_score(score_serialized)
    return unless score_serialized

    score = Zold::Score.load score_serialized
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
