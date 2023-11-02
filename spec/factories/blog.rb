# frozen_string_literal: true

FactoryBot.define do
  factory :blog do
    title {Faker::Lorem.unique.sentence}
    body {Faker::Hipster.sentence(word_count: 15)}
    user
  end
end
