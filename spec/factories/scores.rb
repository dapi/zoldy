# frozen_string_literal: true

FactoryBot.define do
  factory :score, class: Zold::Score do
    host { generate :host }
    port { generate :port }
    time { Time.now }
    invoice { generate :invoice }

    initialize_with { new(attributes) }
  end
end
