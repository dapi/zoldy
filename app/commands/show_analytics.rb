# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity
#
module Commands
  # show_anaytics console command.
  #
  # show analytics by remotes nodes availability and score value
  #
  class ShowAnalytics < Base
    def perform(date = nil)
      date = Date.parse date if date.present?
      print_formatted(
        stats(date),
        headings: ['host', 'no score', 'good score', 'enough score', 'poor score', 'alive', 'dead']
      )
      puts "time from #{@min_time} to #{@max_time}"
    end

    private

    def dir
      @dir ||= Zoldy.app.stores_dir.join('analytics').join('remotes')
    end

    def stats(date = nil)
      @min_time = nil
      @max_time = nil

      load_hosts(date).map do |host, values|
        [
          host,
          values[:no_score],
          values[:good_score],
          values[:enough_score],
          values[:poor_score],
          values[:alive],
          values[:dead]
        ]
      end
    end

    def load_hosts
      hosts = {}
      Dir[dir.join('*.csv')].each do |f|
        time = Time.parse Pathname(f).basename.to_s
        next if date.present? && time.to_date != date

        @min_time = time if @min_time.nil? || time < @min_time
        @max_time = time if @max_time.nil? || time > @max_time
        rows = CSV.read(f)

        load_rows rows
      end

      hosts
    end

    def load_rows(rows)
      rows.each do |row|
        h = @hosts[row.first] ||= { no_score: 0, poor_score: 0, enough_score: 0, good_score: 0, alive: 0, dead: 0 }

        score_value = row[1]
        if score_value == '?'
          h[:no_score] += 1
        elsif score_value.to_i < Zold::Score::STRENGTH
          h[:poor_score] += 1
        elsif score_value.to_i < ScoreWorker::MAX_VALUE
          h[:enough_score] += 1
        else
          h[:good_score] += 1
        end

        if row[2] == 'alive'
          h[:alive] += 1
        else
          h[:dead] += 1
        end
      end
    end
  end
end

# rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity
