class BetsController < ApplicationController
    skip_before_action :authenticate_user!, only: [:leaderboard]

    def create
        game = Game.find(bet_params[:game_id])
        
        if game.closed?
          render json: { error: 'Game is closed for betting' }, status: :unprocessable_entity
          return
        end
    
        if @current_user.balance < bet_params[:amount].to_f
          render json: { error: 'Insufficient balance' }, status: :unprocessable_entity
          return
        end
    
        bet = @current_user.bets.build(bet_params)
        bet.id = SecureRandom.uuid
        
        if bet.save
          @current_user.update!(balance: @current_user.balance - bet_params[:amount].to_f)
          UpdateLeaderboardJob.perform_async
          render json: bet, status: :created
        else
          render json: { errors: bet.errors.full_messages }, status: :unprocessable_entity
        end
      end


      def leaderboard
        @leaderboard = Bet.leaderboard

        render json: @leaderboard, status: :ok
      end
    
      private
    
      def bet_params
        params.require(:bet).permit(:game_id, :amount, :bet_type, :pick, :odds)
      end
end
