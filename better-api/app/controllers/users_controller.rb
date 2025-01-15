class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
  before_action :set_user, only: [:show, :bets]

  def create
    user = User.new(user_params)
    user.id = SecureRandom.uuid
    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def index
    render json: @current_user, status: :ok
  end

  def show
    render json: @user, status: :ok
  end

  def bets
    render json: @user.bets, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :username, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
