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
    @player_grid = GameEngine::Grid.new(@game.player_board).grid
    @opponent_grid = GameEngine::Grid.new(@game.opponent_board).grid
  end

  def update
    @game = Game.find(params[:id])
    #begin
      @game.battle(params[:x], params[:y])
      redirect_to game_path(@game)
    #rescue => e
    #  puts e.inspect
    #  render 'error', :locals => { error: e }
    #end
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
