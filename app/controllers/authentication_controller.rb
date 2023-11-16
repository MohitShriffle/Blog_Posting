# frozen_string_literal: true

# AuthenticationController class
class AuthenticationController < ApplicationController
  include JwtToken
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      return render json: { message: 'You need to Verify Your Email' }, status: 422 unless user.verified != false
      token = jwt_encode({ user_id: user.id })
      render json: { message: 'Login Succesfull', token: }, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
