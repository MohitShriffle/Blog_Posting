class AutoRenewalJob < ApplicationJob
  queue_as :default

  def perform
    subscription_to_renew = Subscription.where(auto_renewal: true ),where('end_date <= ?',Date.today)
    subscription_to_renew.each do |subscription|
      subscription.renew
    end
  end
end
