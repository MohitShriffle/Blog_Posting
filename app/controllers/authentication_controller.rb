
class AuthenticationController < ApplicationController
  skip_before_action :authenticate_user

  include JwtToken
  def login 
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      token = jwt_encode({user_id: @user.id})
      time = Time.now + 24.hours.to_i
      render json: {
        token: token
        }, status: :ok 
    else
        render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
  