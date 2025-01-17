class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
  before_action :set_user, only: [:show, :bets]

  def create
    user = User.new(user_params)
    user.id = SecureRandom.uuid
    if user.save
      token = jwt_encode(user_id: user.id)
      render json: { user: user, token: token }, status: :created
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

  def fund_user_dummy
    @current_user.update!(balance: @current_user.balance + 500)
    render json: { message: 'User balance updated' }, status: :ok
  end

  private

  def user_params
    params.require(:data).permit(:email, :name, :username, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
