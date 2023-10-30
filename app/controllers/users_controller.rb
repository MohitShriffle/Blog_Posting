# frozen_string_literal: true

# class UsersController

class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: %i[create]
  def index; end

  def show
    render json: @current_user
  end

  def create
    user = User.new(user_params)
    if user.save
      # UserMailer.with(user:).welcome_email.deliver_later
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def sent_otp
    return render json: { error: 'Email not present' } if params[:email].blank?

    user = User.find_by(email: params[:email])
    if user.present?
      user.reset_otp
      # UserMailer.sent_otp_email(user).deliver_later
      render json: { status: 'Otp Send Succesfully' }, status: :ok
    else
      render json: { error: ['Email address not found. Please check and try again.'] }, status: :not_found
    end
  end

  def verification
    otp = params[:otp].to_s
    user = User.find_by(otp)
    if user.present? && user.otp_valid
      if user.complete_verification
        render json: { status: 'Varification Successful' }, status: :ok
      else
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: ['Link not valid or expired. Try generating a new link.'] }, status: :not_found
    end
  end

  def update
    if @current_user.update(user_params)
      render json: @current_user
    else
      render json: @current_user.errors.full_messages
    end
  end

  private

  def user_params
    params.permit(
      :name,
      :user_name,
      :email,
      :password,
      :profile_picture,
      :type
    )
  end
end