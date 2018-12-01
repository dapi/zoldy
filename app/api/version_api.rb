# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# /version endpoint for debugging
#
class VersionAPI < Grape::API
  format :txt

  helpers do
    include AutoLogger::Named.new(name: :version_api)
  end

  desc 'Undocumented endpoint. We must implement it to allow other nodes to add as'
  get :version do
    Zoldy.version
  end
end
