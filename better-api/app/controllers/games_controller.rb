class GamesController < ApplicationController
    skip_before_action :authenticate_user!, only: [:index]
    
    def index
        @games = Game.active_games
        render json: @games, status: :ok
    end
end
