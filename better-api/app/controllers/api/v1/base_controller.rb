module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_user!
      
      private
      
      def render_error(message, status = :unprocessable_entity)
        render json: { error: message }, status: status
      end
    end
  end
end
