# frozen_string_literal: true

require 'benchmark'

# Calculate current score and queue itself to calculate next score
#
class ScoreFarmWorker
  include Sidekiq::Worker
  include AutoLogger

  sidekiq_options queue: 'scores_farm'

  # Hack a system and increase your nodes's score
  #
  def self.perform_future_score
    perform_async new.build_score(time: Time.now + 3.days).to_s
  end

  def perform(score_serialized = nil)
    self.class.perform_async generate(score_serialized).to_s
  end

  def generate(score_serialized = nil) # rubocop:disable Metrics/AbcSize
    score = Zold::Score.parse(score_serialized) if score_serialized.present?
    score = scores.best_one || build_score if score.nil? || score.expired?

    logger.debug "Current score: `#{score}`, start calculation of next score"

    bm = Benchmark.measure { score = score.next }
    logger.info "New score value: '#{score}', time spent: #{bm.real} secs"

    store scores << score
    logger.debug 'Scores are saved'

    ReducedScore.new.store score

    score
  end

  def build_score(time: nil)
    Zold::Score
      .new(host: Settings.host, port: Settings.port, invoice: Settings.invoice, time: time || Time.now)
      .next
  end

  private

  delegate :restore, :store, to: :scores_store

  def scores_store
    Zoldy.app.scores_store
  end

  def scores
    @scores ||= restore
  end
end
