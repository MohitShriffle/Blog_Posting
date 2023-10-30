# frozen_string_literal: true

# AuthenticationController class
class ApplicationController < ActionController::Base
  include JwtToken
  attr_accessor :current_user
  before_action :authenticate_user
  skip_before_action :verify_authenticity_token
  
  # before_action do
  #   # ActiveStorage::Current.host = request.base_url
  #   ActiveStorage::Current.url_options = request.base_url
  # end
  # before_action do
  #   ActiveStorage::Current.url_options = { protocol: request.protocol, host: request.host, port: request.port }
  # end
  rescue_from CanCan::AccessDenied do |exception|
    render json: 'Access Denied',status: :unauthorized
  end

  private

  def authenticate_user
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      decoded = jwt_decode(header)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { error: e.message }, status: :unauthorized
    end
  end
  rescue_from ActiveRecord::RecordNotFound, with: :handle_exception

  def handle_exception
    render json: { error: 'ID not found' }
  end
end
