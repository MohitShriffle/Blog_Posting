# frozen_string_literal: true

# subcription class
class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan
  validates :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: %w[active expired canceled],
                                  message: '%<value>s is not a valid status' }

  def renew
    return unless auto_renewal

    new_end_date = end_date + 1.month
    update(end_date: new_end_date, status: 'active')
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[auto_renewal created_at end_date id plan_id start_date status updated_at user_id]
  end
end
