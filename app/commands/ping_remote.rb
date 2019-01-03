# frozen_string_literal: true

# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

require 'sidekiq/testing'

module Commands
  # Ping remote node
  #
  class PingRemote < Base
    def perform(node_alias)
      worker = PingWorker.new
      worker.instance_variable_set '@logger', ActiveSupport::Logger.new(STDOUT)
      Sidekiq::Testing.inline! do
        worker.perform node_alias
      end
    end
  end
end
