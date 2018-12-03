module Zoldy
  module Stores
    class ScoresStore
      LINE_SPLITTER = "\n"

      def initialize(file: nil)
        @file = file || raise('Must be a file path')
      end

      # @param [Zoldy::Entities::Scores] scores
      #
      def store(scores)
        IO.write file, dump(scores)
      end

      # @return Zoldy::Entities::Scores
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

      def parse(ms)
        list = ms.split(LINE_SPLITTER).map { |s| Zold::Score.parse s }

        Zoldy::Entities::Scores.new(list)
      end
    end
  end
end
