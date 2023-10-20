# frozen_string_literal: true

# class Plan
class Plan < ApplicationRecord
  has_many :subscriptions
  validates :name, inclusion: { in: %w[Basic Premium], message: '%<value>s is not a valid name' }
  validates :duration, inclusion: { in: %w[Weekly Monthly], message: '%<value>s is not a valid duration' }
  validates :duration, :price, :active, presence: true
  has_many :users, through: :subscriptions
end
