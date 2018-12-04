# frozen_string_literal: true

# Asynchonous adds remote host to local store.
#
class AddRemoteWorker
  include Sidekiq::Worker

  def perform(node_alias)
    Zoldy.app.remotes_store.add Remote.parse node_alias
  end
end
