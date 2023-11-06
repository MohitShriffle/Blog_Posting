# frozen_string_literal: true

# class ResetUserBlogViewsWorker
class ResetUserBlogViewsWorker
  include Sidekiq::Worker
  def perform
    u = User.all
    u.update_all(blog_views_count: 0)
  end
end
