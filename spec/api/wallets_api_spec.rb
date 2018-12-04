# frozen_string_literal: true

require 'spec_helper'
require 'rack/test'

describe WalletsAPI do
  include Rack::Test::Methods

  def app
    WalletsAPI
  end

  let(:body) { File.read './spec/fixtures/wallet' }
  let(:wallet_id) { '0000000000000001' }

  it do
    put "/wallet/#{wallet_id}", body, 'CONTENT_TYPE' => 'text/plain'
    expect(last_response.status).to eq 304
  end
end
