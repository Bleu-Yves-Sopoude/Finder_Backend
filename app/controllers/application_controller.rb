class ApplicationController < ActionController::API
    # 🔐 Run this before any controller action
    before_action :authorize_request

    # 👤 Makes current_user available in all controllers
    attr_reader :current_user

    private

    # ✅ Token checking logic
    def authorize_request
      header = request.headers["Authorization"]
      token = header.split(" ").last if header

      begin
        decoded = JsonWebToken.decode(token)            # Decode JWT token
        @current_user = User.find(decoded[:user_id])    # Find user by ID in token
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: "User not found" }, status: :unauthorized
      rescue JWT::ExpiredSignature => e
        render json: { error: "Token has expired" }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { error: "Invalid token" }, status: :unauthorized
      end
    end
end
