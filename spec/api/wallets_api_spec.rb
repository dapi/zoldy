# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'spec_helper'

describe WalletsAPI do
  include Rack::Test::Methods

  def app
    Middleware.new WalletsAPI
  end

  let(:body) { File.read './spec/fixtures/wallet' }
  let(:wallet_id) { '0000000000000001' }
  let(:score) { build(:score).next }

  before do
    header Protocol::SCORE_HEADER, score.to_s
    header Protocol::NETWORK_HEADER, Settings.network
    header Protocol::PROTOCOL_HEADER, Protocol::VERSION
  end

  context 'when push wallet' do
    it 'accepts' do
      put "/wallet/#{wallet_id}", body
      expect(last_response.status).to eq 202
    end

    it 'if the content is the same as the one the node already has' do
      put "/wallet/#{wallet_id}", body
      put "/wallet/#{wallet_id}", body
      expect(last_response.status).to eq 304
    end

    pending 'has corrupted data' do
      put "/wallet/#{wallet_id}", body
      expect(last_response.status).to eq 400
    end

    pending 'taxes are not paid' do
      put "/wallet/#{wallet_id}", body
      expect(last_response.status).to eq 402
    end
  end
end
