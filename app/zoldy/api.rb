# frozen_string_literal: true

require 'lib/pretty_json_formatter'

module Zoldy
  class API < Grape::API
    format :json
    default_format :json
    formatter :json, PrettyJSONFormatter

    helpers do
      def zold_headers
        headers.slice(*Zoldy::Middleware::HEADERS)
      end
    end

    before do
      #network = headers[Zoldy::Middleware::NETWORK_HEADER]
      #error(400, "Network name mismatch at #{request.url}, #{request.ip} is in '#{Zoldy::Middleware::NETWORK_HEADER}', \
#while #{Settings.node_alias} is in '#{Settings.network}'") unless network == Settings.network

      #protocol = headers[Zoldy::Middleware::PROTOCOL_HEADER]
      #unless protocol.to_i == Settings.protocol
        #error(400, "Protocol mismatch, you are in '#{Zoldy::Middleware::PROTOCOL_HEADER}', we are in '#{Settings.protocol}'")
      #end
    end

    # Protocol implementation
    #
    mount Ping
    mount Remotes

    mount Version
    mount NotFound

    add_swagger_documentation api_version: 'v1'
  end
end
