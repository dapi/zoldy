module Zoldy
  module Stores
    class RemotesStore
      LINE_SPLITTER = "\n"

      def initialize(file: nil)
        @file = file || raise('Must be a file path')
      end

      def store(remotes)
        raise 'not impelmeneted'
      end

      def restore
        parse read
      end

      private

      attr_reader :file

      def read
        IO.read file
      rescue Errno::ENOENT
        ''
      end

      def parse(ms)
        list = ms.split(LINE_SPLITTER).map do |r|
          host, port = r.split(',')
          Zoldy::Entities::Remote.new(host: host, port: port)
        end

        Zoldy::Entities::Remotes.new list
      end
    end
  end
end
