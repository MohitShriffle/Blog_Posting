# frozen_string_literal: true

# class UsersController
class UsersController < ApplicationController
  before_action :authenticate_user, except: %i[create send_otp verification]
  before_action :set_user, only: :verification
  def index
    users = User.all
    render json: users, status: :ok
    # render json: users.page(params[:page])
  end

  def show
    render json: @current_user
  end

  def create
    user = User.new(user_params)
    if user.save
      # UserMailer.with(user:).welcome_email.deliver_now
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def send_otp
    unless (user = User.find_by(email: params[:email]))
      return render json: { error: ['Email address not found. Please check and try again.'] },
                    status: :not_found
    end

    user.reset_otp
    UserMailer.sent_otp_email(user).deliver_now
    render json: { status: 'Otp Send Succesfully' }, status: :ok
  end

  def verification
    unless @user.otp_valid
      return render json: { error: ['Link not valid or expired. Try generating a new link.'] },
                    status: :unprocessable_entity
    end

    render json: { status: 'Verification Successful' }, status: :ok if @user.complete_verification
  end

  def update
    if @current_user.update(user_params)
      render json: @current_user
    else
      render json: { messages: @current_user.errors.full_messages }, status: :unprocessable_entity
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

  def set_user
    return if (@user = User.find_by(otp: params[:otp].to_s))

    render json: { error: ['User not present for this otp'] },
           status: 404
  end
end
