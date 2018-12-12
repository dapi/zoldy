# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>
# frozen_string_literal: true

require_relative 'boot'

Bundler.require :default, ENV['RACK_ENV']

require 'active_support'
require 'active_support/dependencies'
require 'semver'
require 'lib/http_client'

ActiveSupport::Dependencies.mechanism = :require
ActiveSupport::Dependencies.autoload_paths += %w[
  app
  app/workers
  app/concerns
  app/api
  app/middleware
  app/entities
  app/stores
]

# Core application namespace
#
module Zoldy
  require 'app/protocol'
  require 'app/stores/remotes_store'
  require 'app/stores/wallets_store'
  require 'app/stores/scores_store'

  VERSION = SemVer.find

  def self.version
    'Z' + VERSION.format('%M.%m.%p%s') # rubocop:disable Style/FormatStringToken
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

  def self.root
    @root ||= Pathname File.expand_path('..', __dir__)
  end

  def self.logger
    @logger ||= ActiveSupport::Logger.new(root.join('log', 'zoldy.log'))
                                     .tap { |logger| logger.formatter = Logger::Formatter.new }
  end
end
