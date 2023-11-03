# frozen_string_literal: true

# class AutoRenewalJob
class AutoRenewalJob < ApplicationJob
  queue_as :default

  def perform
    subscription_to_renew = Subscription.where(auto_renewal: true).where('end_date <= ?', Date.today)
    subscription_to_renew.each(&:renew)
  end
end
