# frozen_string_literal: true

# class UsersController

class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: %i[create]
  def index; end

  def show; end

  def create
    user = User.new(user_params)
    UserMailer.with(user:).welcome_email.deliver_later
    if user.save
      UserMailer.with(user:).welcome_email.deliver_later
      # UserMailer.sent_otp_email(user).deliver_later
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :user_name,
      :email,
      :password,
      # :profile_picture,
      :type
    )
  end
end
