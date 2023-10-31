# frozen_string_literal: true

# class SubscriptionsController
class SubscriptionsController < ApplicationController
  before_action :get_subscription, only: %i[show update destroy]
  load_and_authorize_resource
  def index
    render json: @current_user.subscriptions
  end

  def show
    render json: @subscription
  end

  def create
    plan = Plan.find(subscription_params[:plan_id])
    subscription = @current_user.build_subscription(subscription_params.merge(plan_id: plan.id))
    if subscription.save
      render json: subscription, status: :created
    else
      render json: { errors: subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @subscription.update(subscription_params)
      render json: @subscription, status: :ok
    else
      render json: { message: @subcription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @subscription.destroy
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

  def get_subscription
    Subscription.find(params[:id])
  end
end
