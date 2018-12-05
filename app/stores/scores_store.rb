# frozen_string_literal: true

# Saves and restores Zold::Score to the file system
#
class ScoresStore
  LINE_SPLITTER = "\n"

  delegate :best_one, to: :restore

  def initialize(file: nil)
    @file = file || raise('Must be a file path')
  end

  # @param [::Scores] scores
  #
  def store(scores)
    IO.write file, dump(scores)
  end

  # @return ::Scores
  #
  def restore
    parse(read).freeze
  end

  private

  attr_reader :file

  def read
    IO.read file
  rescue Errno::ENOENT
    ''
  end

  def dump(scores)
    scores.join LINE_SPLITTER
  end

  def parse(text)
    list = text.split(LINE_SPLITTER).map { |s| Zold::Score.parse s }

    ::Scores.new(list)
  end
end
