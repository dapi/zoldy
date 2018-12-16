# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Protocol supportes /remotes endpoint
# Returns available list of <Remote> nodes
#
class RemotesAPI < Grape::API
  include ::ApiHelpers

  format :json
  default_format :json
  formatter :json, PrettyJSONFormatter

  desc 'Return remotes list'
  get :remotes do
    zold_present all: Zoldy.app.remotes_store.all.map(&:as_json)
  end
end
