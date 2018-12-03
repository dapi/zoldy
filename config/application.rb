# frozen_string_literal: true

require_relative 'boot'

Bundler.require :default, ENV['RACK_ENV']

require 'active_support'
require 'active_support/dependencies'
require 'semver'
require 'lib/http_client'

ActiveSupport::Dependencies.mechanism = :require
ActiveSupport::Dependencies.autoload_paths += %w[app app/workers app/concerns app/api app/entities app/stores]

# Core application namespace
#
module Zoldy
  VERSION = SemVer.find

  def self.lock_manager
    @lock_manager ||= Redlock::Client.new([Settings.redlock_redis.symbolize_keys]).freeze
  end

  def self.env
    @env ||= ActiveSupport::StringInquirer.new(ENV['RACK_ENV']).freeze
  end

  def self.protocol
    @protocol ||= Protocol.new
  end

  def self.app
    @app ||= Application.new
  end
end
