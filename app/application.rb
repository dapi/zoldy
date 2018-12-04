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
    RequestStore.store[:remotes] ||= remotes_store.restore.presence || default_remotes
  end

  def scores
    RequestStore.store[:scores] ||= scores_store.restore
  end

  def score
    scores.best_one || ScoreFarmWorker.new.build_score
  end

  def wallets_store
    @wallets_store ||= ::WalletsStore.new(dir: stores_dir.join('wallets'))
  end

  def remotes_store
    @remotes_store ||= ::RemotesStore.new(file: stores_dir.join('remotes.txt'))
  end

  def scores_store
    @scores_store ||= ::ScoresStore.new(file: stores_dir.join('scores.txt'))
  end

  def stores_dir
    @stores_dir ||= Pathname build_and_make_stores_dir
  end

  private

  def default_remotes
    Remotes.new(
      Settings.default_remotes.map { |r| Remote.parse r }
    ).freeze
  end

  def build_and_make_stores_dir
    dir = File.expand_path Settings.stores_dir, Zoldy.root
    Dir.mkdir dir unless Dir.exist? dir
    dir
  end
end
