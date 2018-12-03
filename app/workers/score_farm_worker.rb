# frozen_string_literal: true

require 'benchmark'

# Calculate current score and queue itself to calculate next score
#
class ScoreFarmWorker
  include Sidekiq::Worker
  include AutoLogger

  def perform(score_serialized = nil)
    self.class.perform_async generate(score_serialized).to_s
  end

  def generate(score_serialized = nil) # rubocop:disable Metrics/AbcSize
    score = score_serialized.present? ? Zold::Score.parse(score_serialized) : build_score
    logger.debug "Current score: `#{score}`, start calculation of next score"

    bm = Benchmark.measure { score = score.next }
    logger.info "New score value: '#{score}', time spent: #{bm.real} secs"

    store scores << score
    logger.debug 'Scores are saved'

    score
  end

  private

  delegate :restore, :store, to: :scores_store

  def scores_store
    Zoldy.app.scores_store
  end

  def scores
    @scores ||= restore
  end

  def build_score
    scores.best_one ||
      Zold::Score.new(host: Settings.host, port: Settings.port, invoice: Settings.invoice)
  end
end
