# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

require 'csv'

module Commands
  # Base class for console command
  #
  class Base
    def initialize(format: :table)
      @format = format
    end

    def perform
      raise 'uninitialized'
    end

    def get_binding # rubocop:disable Naming/AccessorMethodName
      binding
    end

    private

    attr_reader :format

    def output
      STDOUT
    end

    def print_formatted(rows, headings: [])
      if format == :table
        output.puts Terminal::Table.new(rows: rows, headings: headings)
      else
        output.puts rows.to_csv
      end
    end
  end
end
