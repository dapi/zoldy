# frozen_string_literal: true

# Save current score to analytics history log
#
class ScoreHistoryWorker
  include Sidekiq::Worker
  include AutoLogger

  def perform
    score = scores_store.restore.best_one
    File.open(file_name, 'a') do |f|
      f.puts [Time.now, score.time, score.age, score.value].join "\t"
    end
  end

  private

  def file_name
    './log/scores_history.log'
  end
end
