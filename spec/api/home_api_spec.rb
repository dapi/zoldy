# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'spec_helper'

describe HomeAPI do
  include Rack::Test::Methods

  def app
    HomeAPI
  end

  it do
    get '/', 'CONTENT_TYPE' => Protocol::DATA_CONTENT_TYPE
    expect(last_response.status).to eq 200
  end
end
