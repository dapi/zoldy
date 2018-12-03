class AddRemoteWorker
  include Sidekiq::Worker
  include AutoLogger

  def perform(score)
    remote = Zoldy::Entities::Remote.build_from_score Score.parse score

    Zoldy.app.remotes_store.store Zoldy.app.remotes << remote
  end
end
