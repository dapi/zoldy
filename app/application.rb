# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Core application class. God object.
#
class Application
  attr_reader :started_at

  def initialize
    @started_at = Time.now
    wallets_store
    remotes_store
    scores_store
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

  def log_dir
    @log_dir ||= build_log_dir
  end

  private

  def build_log_dir
    dir = Zoldy.root.join 'log'
    dir = dir.join Zoldy.env unless Zoldy.env.production?
    FileUtils.mkdir_p dir unless Dir.exist? dir
    dir
  end

  def build_and_make_stores_dir
    dir = File.expand_path Settings.stores_dir, Zoldy.root
    FileUtils.mkdir_p dir unless Dir.exist? dir
    dir
  end
end
