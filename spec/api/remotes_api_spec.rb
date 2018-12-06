# frozen_string_literal: true

require 'spec_helper'

describe RemotesAPI do
  include Rack::Test::Methods

  def app
    RemotesAPI
  end

  it do
    get '/remotes', 'CONTENT_TYPE' => Protocol::DATA_CONTENT_TYPE
    expect(last_response.status).to eq 200
  end
end
