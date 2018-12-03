# frozen_string_literal: true

class AddRemoteWorker
  include Sidekiq::Worker
  include AutoLogger

  def perform(score)
    remote = ::Remote.build_from_score Zold::Score.parse_text score

    logger.debug "We probably need to add #{remote}"

    Zoldy.app.remotes_store.add remote
  end
end