class ResetblogviewJob < ApplicationJob
  queue_as :default

  def perform(*args)
    b=BlogView.all
    b.destroy_all
  end
end
