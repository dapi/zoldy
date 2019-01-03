# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

module Commands
  # Show remotes list in console.
  #
  # Usage example
  #
  # > ./bin/console show_remotes
  #
  class ShowRemotes < Base
    # Prints remotes list
    #
    # @param vitality [String] remote nodes vitality (any, alive, dead)
    # @return [String] the contents of remotes nodes data
    def perform(alive_only: true)
      puts 'Pings every minute'
      print_formatted(
        remotes(alive_only),
        headings: ['Node', 'Score', 'Alive?', 'Touched', 'Errors in last hour', 'Last error']
      )
    end

    def remotes(alive_only) # rubocop:disable Metrics/AbcSize
      store.send(alive_only ? :alive : :all).map do |remote|
        [
          remote.to_s,
          store.get_score(remote).try(:value) || '?',
          store.alive?(remote) && 'alive',
          store.touched_at(remote),
          store.errors_in_period(remote, 1.hour),
          store.last_error(remote).to_s.truncate(40)
        ]
      end
    end

    def store
      @store ||= Zoldy.app.remotes_store
    end
  end
end
