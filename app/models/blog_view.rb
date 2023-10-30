# frozen_string_literal: true

# class BlogView
class BlogView < ApplicationRecord
  belongs_to :user
  belongs_to :blog
  def self.ransackable_attributes(auth_object = nil)
    ["blog_id", "created_at", "id", "updated_at", "user_id", "viewed_at"]
  end
end
