# frozen_string_literal: true

# blog class
class Blog < ApplicationRecord
  belongs_to :user
end
