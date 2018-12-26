# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>
# frozen_string_literal: true

# Purges expired scores, perform async ScoreWorker
#
class ScoresWatchDog
  include Sidekiq::Worker

  def perform
    Zoldy.app.scores_store.clear_expired_scores!
    ScoreWorker.perform_async
  end
end
