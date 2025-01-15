class BetsController < ApplicationController
    before_action :authenticate_user!

    def create
        game = Game.find(bet_params[:game_id])
        
        if game.closed?
          render json: { error: 'Game is closed for betting' }, status: :unprocessable_entity
          return
        end
    
        if current_user.balance < bet_params[:amount].to_f
          render json: { error: 'Insufficient balance' }, status: :unprocessable_entity
          return
        end
    
        bet = current_user.bets.build(bet_params)
        
        if bet.save
          current_user.update(balance: current_user.balance - bet_params[:amount].to_f)
          render json: bet, status: :created
        else
          render json: { errors: bet.errors.full_messages }, status: :unprocessable_entity
        end
      end


      def leaderboard
        @leaderboard = User.joins(:bets)
                          .where(bets: { status: 'won' })
                          .group(:id)
                          .order('SUM(bets.amount) DESC')
                          .limit(10)
                          .select('users.*, SUM(bets.amount) AS total_winnings')

        render json: @leaderboard, status: :ok
      end
    
      private
    
      def bet_params
        params.require(:bet).permit(:game_id, :amount, :bet_type, :pick, :odds)
      end
end
