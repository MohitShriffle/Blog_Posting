# frozen_string_literal: true

# AuthenticationController class
class AuthenticationController < ApplicationController
  include JwtToken
  def login
    @user = User.find_by(email: params[:email])
    if @user.verified != false
      if @user&.authenticate(params[:password])
        token = jwt_encode({ user_id: @user.id })
        render json: { token: }, status: :ok
      else
        render json: { error: 'Unauthorized' }, status: :unauthorized
      end
    else
      render json: { message: 'You need to Verify Your Email' }
    end
  end
end
