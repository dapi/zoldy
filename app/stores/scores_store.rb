# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Saves and restores Zold::Score to the file system
#
class ScoresStore < FileSystemStore
  EXPIRED_PERIOD = 24.hours
  # @param [Zold::Score]
  #
  def save!(score)
    score_dir = dir.join score.time.utc.iso8601
    FileUtils.mkdir_p score_dir
    IO.write score_dir.join(score.value.to_s), score.to_s
    remove_weak_scores score_dir
    score
  end

  def clear_expired_scores!
    Pathname.new(dir).children.each do |score_dir|
      remove_score_dir score_dir if score_expired? score_dir
    end
  end

  def find_by_time(time)
    load_best dir.join time.utc.iso8601
  rescue Errno::ENOENT
    nil
  end

  def remove_by_time(time)
    FileUtils.remove_dir dir.join time.utc.iso8601
  rescue Errno::ENOENT
    nil
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
      load_best score_dir
    end
  end

  def build(time: nil)
    Zold::Score
      .new(host: Settings.host, port: Settings.port, invoice: Settings.invoice, time: time || Time.now)
  end

  private

  def score_expired?(score_dir)
    Time.parse(score_dir.basename.to_s) < Time.now - EXPIRED_PERIOD
  rescue ArgumentError
    nil
  end

  def remove_score_dir(score_dir)
    FileUtils.remove_dir score_dir
  rescue StandardError
    Errno::ENOENT
  end

  def load_best(score_dir)
    Zold::Score.load(
      File.read(
        score_dir.children.max_by { |a| a.basename.to_s.to_i }
      )
    )
  end

  def remove_weak_scores(score_dir)
    score_values = score_dir.children.sort_by { |a| a.basename.to_s.to_i }
    values_to_remove = score_values.first score_values.size - 1
    File.delete(*values_to_remove) if values_to_remove.any?
  end
end
