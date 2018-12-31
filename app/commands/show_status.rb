# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

module Commands
  # Show current node's status
  #
  class ShowStatus < Base
    def perform
      print_formatted status
    end

    private

    def status # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      [
        ['Current node', Settings.node_alias],
        ['Network', Settings.network],
        ['Wallets', Zoldy.app.wallets_store.count],
        ['Score strengh', Zold::Score::STRENGTH],
        ['Network nodes (live/total)', inspect_remotes],
        ['Invoice', Settings.invoice],
        ['Using score', inspect_score(Zoldy.app.scores_store.best)],
        ['Generating score', inspect_score(Zoldy.app.scores_store.last)],
        ['Sidekiq proccessing, queue, retry', sidekiq_stats]
      ]
    end

    def inspect_remotes
      [Zoldy.app.remotes_store.alive.count, Zoldy.app.remotes_store.count].join('/')
    end

    def sidekiq_stats
      [
        Sidekiq::Stats.new.processes_size,
        Sidekiq::Stats.new.enqueued,
        Sidekiq::Stats.new.retry_size
      ].join(', ')
    end

    def inspect_score(score)
      return '-' unless score.is_a? Zold::Score

      hours = ((Time.now - score.time) / 1.hours)

      "#{score.value} prefixes, created #{hours.round(2)} hours ago"
    end
  end
end
