# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    user_name { Faker::Internet.unique.user_name }
    email { Faker::Internet.unique.email }
    password { 'password123' }
    profile_picture { nil }
    type { 'Normal' }
  end
end
