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
      begin
        @game.register(game_params[:player_name], game_params[:player_email])
        redirect_to game_path(@game)
      rescue => e
        render 'error', :locals => { error: e }
      end
    else
      render 'new'
    end
  end

  def show
    @game = Game.find(params[:id])
    if @game.over
      render 'over'
    else
      @player_grid = GameEngine::Grid.new(@game.player_board).grid
      @opponent_grid = GameEngine::Grid.new(@game.opponent_board).grid
    end
  end

  def update
    @game = Game.find(params[:id])
    begin
      @game.battle(params[:x].to_i, params[:y].to_i)
      redirect_to game_path(@game)
    rescue => e
      render 'error', :locals => { error: e }
    end
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