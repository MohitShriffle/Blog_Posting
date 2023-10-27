# frozen_string_literal: true

# class SubscriptionsController
class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[show update]

  def index
    render json: @current_user.subscriptions
  end

  def show
    render json: @subscription
  end

  def create
    plan = Plan.find(subscription_params[:plan_id])
    byebug
    subscription = @current_user.build_subscription(subscription_params.merge(plan_id: plan.id))
    if subscription.save
      render json: subscription, status: :created
    else
      render json: { errors: subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    return unless @subscription.user == @current_user

    if @subscription.update(subscription_params)
      render json: @subcription, status: :ok
    else
      render json: { message: @subcription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    return unless @subscription.user == @current_user

    if @subcription.destroy
      render json: { message: 'Subscription Deleted Succesfully' }
    else
      @subcription.errors.full_messages
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(
      :start_date,
      :end_date,
      :auto_renewal,
      :status,
      :plan_id,
      :user_id
    )
  end

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end
end
