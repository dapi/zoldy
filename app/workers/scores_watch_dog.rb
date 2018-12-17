# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>
# frozen_string_literal: true

# Controll ScoreWorker in sidekiq queues
#
class ScoresWatchDog
  include Sidekiq::Worker
  include AutoLogger

  def perform
    Zoldy.app.scores_store.clear_expired_scores!
    start_new_score_if_need
  end

  private

  def start_new_score_if_need
    return unless last_time.nil? || last_time < Time.now - period_between_scores

    logger.info 'Perform async new score calculation'
    Commands.new.perform_new_score
  end

  def last_time
    score_times.max
  end

  def score_times
    Sidekiq::Workers.new.map do |_process_id, _thread_id, work|
      j = Sidekiq::Job.new(work['payload'])
      j.klass == ScoreWorker.name ? Time.parse(j.args.first) : nil
    end.compact
  end

  def period_between_scores
    Zold::Score::EXPIRATION_PERIOD / Sidekiq::Stats.new.processes_size
  end
end
