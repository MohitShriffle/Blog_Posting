# frozen_string_literal: true

# class ResetBlogViewScheduler
class ResetBlogViewWorker
  include Sidekiq::Worker
  def perform
    BlogView.destroy_all
  end
end
