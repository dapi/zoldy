# frozen_string_literal: true

require_relative 'boot'

Bundler.require :default, ENV['RACK_ENV']

require 'active_support'
require 'active_support/dependencies'
require 'semver'

ActiveSupport::Dependencies.mechanism = :require
ActiveSupport::Dependencies.autoload_paths += %w[app app/workers]

module Zoldy
  VERSION = SemVer.find

  class Application
    attr_reader :started_at

    def initialize
      @started_at = Time.now
    end

    def lock_manager
      @lock_manager ||= Redlock::Client.new([ Settings.redlock_redis.symbolize_keys ])
    end

    def protocol
      @protocol ||= Zoldy::Protocol.new
    end

    def wallets
      @wallets ||= [] # wallets_store.restore
    end

    def remotes
      RequestStore.store[:remotes] ||= remotes_store.restore
    end

    def scores
      RequestStore.store[:scores] ||= scores_store.restore
    end

    def score
      scores.best_one
    end

    def remotes_store
      @remotes_store ||= Zoldy::Stores::RemotesStore.new(file: Settings.remotes_file)
    end

    def scores_store
      @scores_store ||= Zoldy::Stores::ScoresStore.new(file: Settings.scores_file)
    end

    def threads
      Thread.list
    end

    def uptime
      Time.now - Zoldy.app.started_at
    end
  end

  def self.app
    @application ||= Application.new
  end
end
