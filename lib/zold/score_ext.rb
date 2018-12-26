# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Zold
  # We need to do it because parsing score changes it's time zone and created attributes
  #
  class Score
    EXPIRATION_PERIOD = 24.hours

    # Autodetect serialized format and parse it
    #
    def self.load(value)
      parse value
    end

    def node_alias
      [host, port].join(':').freeze
    end

    def ==(other)
      hash == other.hash
    end
  end
end
