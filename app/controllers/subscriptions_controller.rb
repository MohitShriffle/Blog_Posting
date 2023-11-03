# frozen_string_literal: true

# class SubscriptionsController
class SubscriptionsController < ApplicationController
  before_action :get_subscription, only: %i[show update destroy]
  before_action :authenticate_user
  load_and_authorize_resource
  def index
    byebug
    render json: @current_user.subscription,status: :ok
  end

  def show
    render json: @subscription,status: :ok
  end
  
  def create
    return render json: { error: 'Please Select Your Plan ' } unless params[:plan].blank?
    plan= Plan.find_by(params[:plan_id].to_s) 
    if plan.present? && plan.price == params[:price].to_d
      if plan.duration == "weekly"
        subscription = @current_user.build_subscription(start_date: Date.today,end_date: Date.today+7,status: 'active',auto_renewal: params[:auto_renewal],plan_id: plan.id)        
        render json: subscription ,status: :created if subscription.save
      else
        subscription = @current_user.build_subscription(start_date: Date.today,end_date: Date.today+30,status: 'active',auto_renewal: params[:auto_renewal],plan_id: plan.id)
        render json: subscription,status: :created if subscription.save
      end
    else
      render json: {message: "Plan not Present in this price"},status: :unprocessable_entity
    end 
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
      render json: { message: 'Subscription Deleted Succesfully' }
    else
      @subscription.errors.full_messages
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

  def get_subscription
    @subscription = Subscription.find_by(params[:id])
    unless @subscription
      render json: {message: "subscription Not Found"},status: 404
    end
  end
end
