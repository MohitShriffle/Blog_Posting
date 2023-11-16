# frozen_string_literal: true

# class SubscriptionsController
class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[show update destroy]
  before_action :set_plan, only: :create
  before_action :authenticate_user
  load_and_authorize_resource
  def index
    byebug
    render json: @current_user.subscription, status: :ok
  end

  def show
    render json: @subscription, status: :ok
  end

  def create
    return unless check_valid_attributes == true

    duration = { weekly: 7, monthly: 30 }
    subscription = Subscription.new(
      start_date: Date.today,
      end_date: Date.today + duration[@plan.duration.parameterize.underscore.to_sym],
      status: 'active',
      auto_renewal: params[:auto_renewal],
      plan: @plan,
      user: @current_user
    )
    render json: subscription, status: 201 if subscription.save
  end

  def update
    if @subscription.update(subscription_params)
      render json: @subscription, status: :ok
    else
      render json: { message: @subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @subscription.destroy
      render json: { message: 'Subscription Deleted Succesfully' }, status: 200
    else
      render json: { errors: @subscription.errors.full_messages }, status: 422
    end
  end

  private

  def subscription_params
    params.permit(
      :start_date,
      :end_date,
      :auto_renewal,
      :status,
      :plan_id,
      :user_id
    )
  end

  def check_valid_attributes
    if (@plan.price == params[:price].to_d) && [true, false].include?(params[:auto_renewal] == 'true')
      true
    else
      render json: { message: 'Plan not present for this price and please give valid auto renewal' },
             status: 422
    end
  end

  def set_plan
    render json: { message: 'Plan Not Found' }, status: 404 unless (@plan = Plan.find_by(id: params[:plan_id].to_s))
  end

  def set_subscription
    unless (@subscription = Subscription.find_by(id: params[:id]))
      render json: { message: 'subscription Not Found' },
                        status: 404
    end
  end
end
