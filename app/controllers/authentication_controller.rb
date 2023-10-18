# frozen_string_literal: true

# AuthenticationController class
class AuthenticationController < ApplicationController
  skip_before_action :authenticate_user

  include JwtToken
  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      token = jwt_encode({ user_id: @user.id })
      render json: { token: }, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
