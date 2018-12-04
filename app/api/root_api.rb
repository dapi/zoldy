# frozen_string_literal: true

# Root API agregator
#
class RootAPI < Grape::API
  format :json
  default_format :json
  formatter :json, PrettyJSONFormatter

  if Zoldy.env.development?
    require 'grape_logging'
    logger = ActiveSupport::Logger.new Zoldy.root.join './log/grape.log'
    logger.formatter = GrapeLogging::Formatters::Default.new
    use GrapeLogging::Middleware::RequestLogger, logger: logger
  end

  helpers do
    def zold_headers
      headers.slice(*::Protocol::HEADERS)
    end

    def zold_present(hash)
      hash.reverse_merge(
        version: Zoldy::VERSION.to_s,
        alias: Settings.node_alias,
        score: Zoldy.app.score.to_h,
        wallets: Zoldy.app.wallets.size
      )
    end
  end

  rescue_from WalletsStore::WalletNotFound do |e|
    error! e, 404
  end

  # Protocol implementation
  #
  mount HomeAPI
  mount RemotesAPI
  mount WalletsAPI

  # Debug and other api's
  mount VersionAPI
  mount NotFoundAPI

  add_swagger_documentation api_version: 'v1'
end
