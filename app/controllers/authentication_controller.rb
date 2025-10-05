# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
    before_action :authorize_request

    attr_reader :current_user

    private

    def authorize_request
      header = request.headers['Authorization']
      token = header.split(' ').last if header

      begin
        decoded = JsonWebToken.decode(token)
        @current_user = User.find(decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: 'User not found' }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { error: 'Invalid token' }, status: :unauthorized
      rescue JWT::ExpiredSignature => e
        render json: { error: 'Token has expired' }, status: :unauthorized
      end
    end
  end
