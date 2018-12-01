# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

FactoryBot.define do
  factory :wallet_transaction do
    id { SecureRandom.hex 2 }
    time { Time.now }
    amount { Random.rand(999) }
    prefix { SecureRandom.hex 8 }
    bnf { SecureRandom.hex 8 }
    details { SecureRandom.hex 16 }
    signature { '' }

    initialize_with { new(attributes) }
  end
end
