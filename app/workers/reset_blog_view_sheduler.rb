# frozen_string_literal: true

# class ResetBlogViewScheduler
class ResetBlogViewScheduler
  include Sidekiq::Worker
  def perform
    b = BlogView.all
    b.destroy_all
  end
end
