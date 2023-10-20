# frozen_string_literal: true

# subcription class
class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan
  validates :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: %w[active expired canceled],
                                  message: '%<value>s is not a valid status' }
end
