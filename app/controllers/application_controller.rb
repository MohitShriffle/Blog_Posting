# frozen_string_literal: true

# AuthenticationController class
class ApplicationController < ActionController::Base
  include JwtToken
  attr_accessor :current_user

  skip_before_action :verify_authenticity_token

  before_action do
    ActiveStorage::Current.url_options = { host: request.base_url }
  end


  rescue_from CanCan::AccessDenied do |_exception|
    render json: 'Access Denied', status: :unauthorized
  end

  private

  def authenticate_user
    token = request.headers[:token] || params[:token]
    # header = request.headers['Authorization']
    token = token.split(' ').last if token
    begin
      decoded = jwt_decode(token)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { error: e.message }, status: :unauthorized
    end
  end
  rescue_from ActiveRecord::RecordNotFound, with: :handle_exception

  def handle_exception
    render json: { error: 'ID not found' },status: :not_found
  end
end
