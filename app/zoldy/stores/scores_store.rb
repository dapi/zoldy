module Zoldy
  module Stores
    class ScoresStore
      include Virtus.model

      LINE_SPLITTER = "\n"

      attribute :scores_file, String, default: ->(s,o) { Settings.scores_file }

      # @param [Zoldy::Entities::Scores] scores
      #
      def save
        IO.write scores_file, dump(scores)
      end

      # @return Zoldy::Entities::Scores
      #
      def load
        parse IO.read scores_file
      end

      private

      def dump(scores)
        scores.best.join LINE_SPLITTER
      end

      def parse(ms)
        list = ms.split(LINE_SPLITTER).map { |s| Zold::Score.parse s }

        Zoldy::Entities::Scores.new(list).best
      end
    end
  end
end
