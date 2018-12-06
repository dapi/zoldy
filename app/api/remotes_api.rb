# frozen_string_literal: true

# Protocol supportes /remotes endpoint
# Returns available list of <Remote> nodes
#
class RemotesAPI < Grape::API
  format :json
  default_format :json
  formatter :json, PrettyJSONFormatter

  desc 'Return remotes list'
  get :remotes do
    zold_present all: Zoldy.app.remotes_store.remotes.map(&:as_json)
  end
end
