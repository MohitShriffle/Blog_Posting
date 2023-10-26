# frozen_string_literal: true

# class PlanSerializer
class PlanSerializer < ActiveModel::Serializer
  attributes :id, :duration, :price, :active
end
