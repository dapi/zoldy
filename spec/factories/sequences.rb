# frozen_string_literal: true

require 'securerandom'

FactoryBot.define do
  sequence :wallet_body do
    SecureRandom.hex(10)
  end

  sequence :wallet_id do
    SecureRandom.hex(10)
  end

  sequence :host do
    SecureRandom.hex(10)
  end

  sequence :port do
    Random.rand(9999).to_i
  end

  sequence :invoice do
    [SecureRandom.hex(4), SecureRandom.hex(10)].join '@'
  end
end
