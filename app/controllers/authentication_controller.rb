class AuthenticationController < ApplicationController
  # Skip the auth check so users can log in without a token
  skip_before_action :authorize_request, only: [ :login ]

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)

      render json: {
        token: token,
        user: {
          id: user.id,
          name: user.name,
          email: user.email,
          is_admin: user.is_admin
        }
      }, status: :ok

    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end
end
