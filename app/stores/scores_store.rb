# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Saves and restores Zold::Score to the file system
#
class ScoresStore < FileSystemStore
  # @param [Zold::Score]
  #
  def save!(score)
    score_dir = dir.join score.time.utc.iso8601
    FileUtils.mkdir_p score_dir
    IO.write score_dir.join(score.value.to_s), score.to_s
    remove_weak_scores score_dir
    score
  end

  def best
    alive.max_by(&:value)
  end

  def alive
    all.reject(&:expired?)
  end

  # Returns list of a best scores grouped by time
  #
  def all
    Pathname.new(dir).children.map do |score_dir|
      Zold::Score.load(
        File.read(
          score_dir.children.max_by { |a| a.basename.to_s.to_i }
        )
      )
    end
  end

  def build(time: nil)
    Zold::Score
      .new(host: Settings.host, port: Settings.port, invoice: Settings.invoice, time: time || Time.now)
  end

  private

  def remove_weak_scores(score_dir)
    score_values = score_dir.children.sort_by { |a| a.basename.to_s.to_i }
    values_to_remove = score_values.first score_values.size - 1
    File.delete(*values_to_remove) if values_to_remove.any?
  end
end
