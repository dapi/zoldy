# frozen_string_literal: true

require_relative 'boot'

Bundler.require :default, ENV['RACK_ENV']

require 'active_support'
require 'active_support/dependencies'
require 'semver'

ActiveSupport::Dependencies.autoload_paths += %w[app]

module Zoldy
  VERSION = SemVer.find

  class Application
    attr_reader :started_at

    def initialize
      @started_at = Time.now
    end

    def wallets
      @wallets ||= WalletsRepository.new
    end

    def remotes
      @remotes ||= RemotesRepository.new
    end

    def scores
      @scores ||= scores_store.load
    end

    def score
      scores.best_one
    end

    def scores_store
      @scores_store ||= Zoldy::Stores::ScoresStore.new(scores_file: Settings.scores_file)
    end

    def threads
      Thread.list
    end

    def uptime
      Time.now - Zoldy.app.started_at
    end
  end

  def self.version
    VERSION.format("%M.%m.%p%s")
  end

  def self.app
    @application ||= Application.new
  end

  def self.redis
    @redis ||= Redis.new Settings.redis.symbolize_keys
  end
end
