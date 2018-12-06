# frozen_string_literal: true

FactoryBot.define do
  factory :wallet do
    id { generate :wallet_id }
    body { generate :wallet_body }

    initialize_with { new(attributes) }
  end
end
