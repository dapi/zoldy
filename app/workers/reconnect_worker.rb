# frozen_string_literal: true

# Each node runs a 'reconnect' procedure every minute,
# updating the list of remote nodes and removing those,
# which have too low availability values.
class ReconnectWorker
  include Sidekiq::Worker
  include AutoLogger

  def perform
    # TODO
  end
end
