# frozen_string_literal: true

FactoryBot.define do
  factory :remote do
    host { 'example.com' }
    port { 4096 }

    initialize_with { new(attributes) }
  end
end
