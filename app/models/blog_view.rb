# frozen_string_literal: true

# class BlogView
class BlogView < ApplicationRecord
  belongs_to :user
  belongs_to :blog
end
