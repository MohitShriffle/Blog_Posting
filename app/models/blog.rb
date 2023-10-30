# frozen_string_literal: true

# blog class
class Blog < ApplicationRecord
  belongs_to :user
  has_many :blogviews, dependent: :destroy

  validates :title, :body, presence: true

  def increment_modification_count
    update(modifications_count: modifications_count + 1)
  end
  def self.ransackable_attributes(auth_object = nil)
    ["body", "created_at", "id", "modifications_count", "title", "updated_at", "user_id"]
  end
end
