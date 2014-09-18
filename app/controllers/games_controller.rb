class GamesController < ApplicationController
  def index
    @games = Game.paginate(page: params[:page])
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(player_name: game_params[:player_name], player_email: game_params[:player_email])
    if @game.valid?
      @game.register(game_params[:player_name], game_params[:player_email])
    end
    if @game.save
      redirect_to game_path(@game)
    else
      render 'new'
    end
  end

  def show
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    @game.battle(params[:x], params[:y]).save
    redirect_to game_path(@game)
  end

  def destroy
    @game = Game.find(params[:id]).destroy
    flash[:success] = "Game deleted!"
    redirect_to games_path
  end

  private

    def game_params
      params.require(:game).permit(:player_name, :player_email)
    end

end
