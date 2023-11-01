# frozen_string_literal: true

# class ResetUserBlogViewsJob
class ResetUserBlogViewsJob < ApplicationJob
  queue_as :default

  def perform
    u = User.all
    u.update_all(blog_views_count: 0)
  end
end
