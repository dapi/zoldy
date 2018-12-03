module Zoldy
  module Entities
    # Eumerabe Zoldy::Score collection
    #
    class Scores
      include Enumerable

      LIFETIME = 24.hours

      delegate :each, :join, to: :list
      delegate :new, to: :class

      def initialize(list=[])
        @list = Array(list)
      end

      def valid
        new select(&:valid?)
          .reject(&:expired?)
          .reject { |s| s.strength < Settings.strength }
      end

      def uniq
        new sort_by(&:value).reverse.uniq(&:time)
        # TODO WTF? .uniq { |s| (s.age / period).round }
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
  end
end
