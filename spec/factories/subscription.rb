# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    start_date {Date.today}
    end_date {Date.today + 7}
    status {'active'}
    auto_renewal { true }
    user
    plan
  end
end
