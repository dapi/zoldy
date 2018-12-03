module Zoldy
  class API::Remotes < Grape::API
    helpers do
      include AutoLogger::Named.new(name: :remote_api)
    end

    format :json
    default_format :json
    formatter :json, PrettyJSONFormatter

    desc 'Return remotes list'
    get :remotes do
      logger.info "Get remotes with headers #{zold_headers}"
      present(
        version: Zoldy::VERSION.to_s,
        alias: Settings.node_alias,
        score: Zoldy.app.score.to_h,
        all:   Zoldy.app.remotes.map(&:as_json)
      )
    end
  end
end
