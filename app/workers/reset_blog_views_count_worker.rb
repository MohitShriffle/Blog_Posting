# frozen_string_literal: true

# class ResetUserBlogViewsWorker
class ResetBlogViewsCountWorker
  include Sidekiq::Worker
  def perform
    User.update_all(blog_views_count: 0)
  end
end
