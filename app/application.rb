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

  def mine_node
    @mine_node ||= Remote.parse Settings.node_alias
  end

  def wallets_store
    @wallets_store ||= ::WalletsStore.new(dir: stores_dir.join('wallets'))
  end

  def remotes_store
    @remotes_store ||= ::RemotesStore.new(dir: stores_dir.join('remotes'))
  end

  def scores_store
    @scores_store ||= ::ScoresStore.new(dir: stores_dir.join('scores'))
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
