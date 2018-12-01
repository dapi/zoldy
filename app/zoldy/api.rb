# frozen_string_literal: true

require 'lib/pretty_json_formatter'

module Zoldy
  class API < Grape::API
    use Middleware

    mount Ping

    add_swagger_documentation api_version: 'v1'
  end
end
