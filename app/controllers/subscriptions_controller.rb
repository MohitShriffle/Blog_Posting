# frozen_string_literal: true

# class SubscriptionsController
class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[show update]

  def index
    render json: @current_user.subscriptions
  end

  def show; end

  def create
    plan = Plan.find(subscription_params[:plan_id])
    subscription = @current_user.build_subscription(subscription_params.merge(plan_id: plan.id))
    if subscription
      render json: subscription, status: :created
    else
      render json: { errors: subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @subcription.update(subscription_params)
      render json: @subcription, status: :ok
    else
      render json: { message: @subcription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(
      :start_date,
      :end_date,
      :auto_renewal,
      :plan_id,
      :user_id
    )
  end

  def set_subscription
    @subscription = @current_user.subscription.find(params[:id])
  end
end
