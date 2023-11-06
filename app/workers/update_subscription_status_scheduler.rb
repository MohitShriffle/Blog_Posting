# class UpdateSubscriptionStatusScheduler
class UpdateSubscriptionStatusScheduler
  include Sidekiq::Worker
  def perform
    subscription_to_update = Subscription.where(auto_renewal: true).where('end_date < ?', Date.today)
    subscription_to_update.update(status: 'expired')
  end
end
