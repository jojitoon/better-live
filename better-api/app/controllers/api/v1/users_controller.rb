module Api
  module V1
    class UsersController < BaseController
      def me
        render json: current_user.as_json(only: [:id, :email, :name, :username])
      end
    end
  end
end
