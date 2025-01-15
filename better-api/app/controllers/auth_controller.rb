class AuthController < ApplicationController
    skip_before_action :authenticate_user!

    def login
        @user = User.find_by(email: params[:email])
        if @user && @user&.authenticate(params[:password])
            token = jwt_encode(user_id: @user.id)
            render json: { token: token }, status: :ok
        else
            render json: { errors: 'Unauthorized' }, status: :unauthorized
        end
    end
end
