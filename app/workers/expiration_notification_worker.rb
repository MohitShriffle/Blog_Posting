# frozen_string_literal: true

# class ExpirationNotificationScheduler
class ExpirationNotificationWorker
  include Sidekiq::Worker
  def perform
    subscriptions_to_notify = Subscription.where(end_date: Date.tomorrow)
    subscriptions_to_notify.each do |subscription|
      UserMailer.expiration_notification(subscription.user).deliver_now
    end
  end
end
