# frozen_string_literal: true

FactoryBot.define do
  factory :plan do
    name {"Basic"}
    duration{"weekly"}
    price{150}
    active { true }
  end
end
