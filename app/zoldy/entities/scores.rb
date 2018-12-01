module Zoldy
  module Entities
    # Eumerabe Zoldy::Score collection
    #
    class Scores
      include Enumerable

      LIFETIME = 24.hours

      delegate :each, to: :scores

      def initialize(scores=[])
        @scores = Array(scores)
      end

      def valid
        select(&:valid?)
          .reject(&:expired?)
          .reject { |s| s.strength < Settings.strength }
      end

      def sort
        sort_by(&:value)
          .reverse
      end

      def unique
        uniq(&:time)
        # TODO WTF? .uniq { |s| (s.age / period).round }
        # .map(&:to_s).uniq # TODO implement uniq in Zold::Score
      end

      def best
        self.class.new(
          valid
          .sort
          .uniq
        )
      end

      def parse(multiline_string)
        self.class.new split("\n").map { |s| Score.parse s }
      end

      def dump
        join("\n")
      end

      private

      attr_reader :scores
    end
  end
end
