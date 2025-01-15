class GamesController < ApplicationController

    def index
        @games = Game.active_games
        render json: @games, status: :ok
    end
end
