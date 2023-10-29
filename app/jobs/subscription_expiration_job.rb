class SubscriptionExpirationJob < ApplicationJob
  queue_as :default
    def perform
      expired_subscriptions = Subscription.where("end_date < ?", Date.today)
      expired_subscriptions.update_all(status: 'expired')
    end
end
