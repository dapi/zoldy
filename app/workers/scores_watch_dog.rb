# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>
# frozen_string_literal: true

# Controll ScoreWorker in sidekiq queues
#
class ScoresWatchDog
  include Sidekiq::Worker
  include AutoLogger

  QUEUE_PREFIX     = 'worker'
  EXPIRATION_HOURS = 24 # 24 hours expiration of Score
  PROCESSORS_COUNT = 4 # Count of processors used to run parallelized score mining
  PERIOD           = EXPIRATION_HOURS / PROCESSORS_COUNT
  QUEUES           = Array.new(PROCESSORS_COUNT) { |i| QUEUE_PREFIX + i.to_s }

  def perform
    Zoldy.app.scores_store.clear_expired_scores!
    # QUEUES.each do |queue|
    # perform_worker queue
    # end
  end

  private

  def workers_count(queue)
    Sidekiq::Queue.new(queue)
                  .select { |a| a.klass == ScoreWorker.to_s }
                  .size
  end
end
