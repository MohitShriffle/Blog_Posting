# frozen_string_literal: true

# class ResetblogviewJob
class ResetblogviewJob < ApplicationJob
  queue_as :default

  def perform
    b = BlogView.all
    b.destroy_all
  end
end
