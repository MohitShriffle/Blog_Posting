# frozen_string_literal: true

# class Plan
class Plan < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  validates :name, inclusion: { in: %w[Basic Premium], message: '%<value>s is not a valid name' }
  enum :duration, %i[weekly monthly]
  validates :duration, :price, :active, presence: true
  has_many :users, through: :subscriptions
  def self.ransackable_attributes(_auth_object = nil)
    %w[active created_at duration id name price updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[subscriptions users]
  end
end
