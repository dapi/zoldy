# frozen_string_literal: true

# Core application class. God object.
#
class Application
  attr_reader :started_at

  def initialize
    @started_at = Time.now
  end

  def uptime
    (Time.now - started_at).freeze
  end

  def wallets
    [] # RequestStore.store[:wallets] ||= wallets_store.restore
  end

  def remotes
    RequestStore.store[:remotes] ||= remotes_store.restore
  end

  def scores
    RequestStore.store[:scores] ||= scores_store.restore
  end

  def score
    scores.best_one || ScoreFarmWorker.new.build_score
  end

  def wallets_store
    @wallets_store ||= ::WalletsStore.new(dir: Settings.wallets_dir)
  end

  def remotes_store
    @remotes_store ||= ::RemotesStore.new(file: Settings.remotes_file)
  end

  def scores_store
    @scores_store ||= ::ScoresStore.new(file: Settings.scores_file)
  end
end
