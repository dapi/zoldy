# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'spec_helper'

describe Middleware do
  include Rack::Test::Methods

  let(:app) { ->(_env) { [200, { 'Content-Type' => 'text/plain' }, ['OK']] } }
  let(:request) { Rack::MockRequest.new described_class.new app }
  let(:score) { build(:score).next }

  let(:headers) do
    {
      'HTTP_' + Protocol::SCORE_HEADER.upcase.tr('-', '_') => score.to_s,
      'HTTP_' + Protocol::NETWORK_HEADER.upcase.tr('-', '_') => Settings.network,
      'HTTP_' + Protocol::PROTOCOL_HEADER.upcase.tr('-', '_') => Protocol::VERSION
    }
  end

  before do
    stub_const 'Zold::Score::STRENGTH', 0
    Sidekiq::Testing.inline!
  end

  it do
    expect(Zoldy.app.remotes_store).to receive(:add)
    request.get '/', headers
  end
end
