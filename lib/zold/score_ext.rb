# frozen_string_literal: true

module Zold
  # We need to do it because parsing score changes it's time zone and created attributes
  #
  class Score
    # Autodetect serialized format and parse it
    #
    def self.load(value)
      if PTN.match?(value.strip)
        parse value
      else
        parse_text value
      end
    end

    def ==(other)
      hash == other.hash
    end
  end
end
