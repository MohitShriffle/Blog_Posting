# frozen_string_literal: true

# subcription class
class Subscription < ApplicationRecord
  has_many :users
end
