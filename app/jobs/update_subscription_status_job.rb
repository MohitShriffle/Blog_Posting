class UpdateSubscriptionStatusJob < ApplicationJob
  queue_as :default

  def perform
    subscription_to_update = Subscription.where(auto_renewal: false).where('end_date < ?', Date.today)
    subscription_to_update.update(status: 'expired')  
  end
end
