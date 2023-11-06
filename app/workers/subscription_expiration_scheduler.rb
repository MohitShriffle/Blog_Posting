# frozen_string_literal: true

# class SubscriptionExpirationScheduler
class SubscriptionExpirationScheduler
  include Sidekiq::Worker
  def perform
    expired_subscriptions = Subscription.where('end_date < ?', Date.today)
    expired_subscriptions.update_all(status: 'expired')
  end
end
