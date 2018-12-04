# frozen_string_literal: true

# Core application class. God object.
#
class Application
  attr_reader :started_at

  delegate :remotes, to: :remotes_store

  def initialize
    @started_at = Time.now
  end

  def uptime
    (Time.now - started_at).freeze
  end

  def wallets
    [] # RequestStore.store[:wallets] ||= wallets_store.restore
  end

  def scores(force = false)
    RequestStore.store[:scores] if force
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

  def build_and_make_stores_dir
    dir = File.expand_path Settings.stores_dir, Zoldy.root
    Dir.mkdir dir unless Dir.exist? dir
    dir
  end
end
