# frozen_string_literal: true

# class SubscriptionSerializer
class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :start_date, :end_date, :status, :auto_renewal
end
