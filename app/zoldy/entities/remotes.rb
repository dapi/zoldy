module Zoldy
  module Entities
    # Eumerabe Zoldy::Remote collection
    #
    class Remotes
      include Enumerable

      delegate :each, :join, :empty?, to: :list

      def initialize(list=[])
        @list = Array(list)
      end

      def nscore
        list.map(&:score).inject(&:+) || 0
      end

      def <<(remote)
        new list + [remote]
      end

      private

      attr_reader :list
    end
  end
end
