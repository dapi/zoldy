# frozen_string_literal: true

module Zold
  # We need to do it because parsing score changes it's time zone and created attributes
  #
  class Score
    def ==(other)
      hash == other.hash
    end
  end
end
