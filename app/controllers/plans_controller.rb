# frozen_string_literal: true

# class PlansController
class PlansController < ApplicationController
  load_and_authorize_resource
  before_action :set_plan, only: %i[show update destroy]
  def index
    render json: Plan.all
  end

  def show
    render json: @plan
  end

  def create
    plan = Plan.new(plan_params)
    if plan.save
      render json: plan, status: :created
    else
      render json: { errors: plan.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @plan.update(plan_params)
      render json: @plan, status: :ok
    else
      render json: { errors: @plan.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @plan.destroy
      render json: { message: 'Plan Deleted Succesfully' }, status: :no_content
    else
      render json: { errors: @plan.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def plan_params
    params.require(:plan).permit(
      :name,
      :duration,
      :price,
      :active
    )
  end

  def set_plan
    @plan = Plan.find_by(params[:id])
  end
end
