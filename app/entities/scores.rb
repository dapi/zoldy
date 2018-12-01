# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Eumerabe Zold::Score collection
#
class Scores
  include Enumerable

  LIFETIME = 24.hours

  delegate :each, :join, to: :list
  delegate :new, to: :class

  # @param Array[Zold::Score]
  #
  def initialize(list = [])
    @list = Array(list)
  end

  def valid
    new(
      select(&:valid?)
      .reject(&:expired?)
      .reject { |s| s.strength < Zold::Score::STRENGTH }
    )
  end

  def uniq
    new sort_by(&:value).reverse.uniq(&:time)
    # TODO: WTF? .uniq { |s| (s.age / period).round }
    # .map(&:to_s).uniq # TODO implement uniq in Zold::Score
  end

  def best
    valid
      .uniq
  end

  def best_one
    best.first
  end

  def <<(score)
    new list + [score]
  end

  private

  attr_reader :list
end
