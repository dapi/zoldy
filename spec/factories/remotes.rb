# Copyright (c) 2018 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

FactoryBot.define do
  factory :remote do
    host { generate :host }
    port { generate :port }

    initialize_with { new(attributes) }
  end
end
