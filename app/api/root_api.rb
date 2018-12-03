# frozen_string_literal: true

require 'lib/pretty_json_formatter'

# Root API agregator
#
class RootAPI < Grape::API
  format :json
  default_format :json
  formatter :json, PrettyJSONFormatter

  helpers do
    def zold_headers
      headers.slice(*::Protocol::HEADERS)
    end
  end

  # Protocol implementation
  #
  mount RemotesAPI

  # Debug and other api's
  mount PingAPI
  mount VersionAPI
  mount NotFoundAPI

  add_swagger_documentation api_version: 'v1'
end
