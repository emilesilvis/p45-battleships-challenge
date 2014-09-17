class GamesController < ApplicationController
  def index
    @games = Game.paginate(page: params[:page])
  end

  def new
    @game = Game.new
  end

  def create

    #Register interaction

    # Empty game object
    @game = Game.new

    # Set name and email
    player_name = game_params[:player_name]
    player_email = game_params[:player_email]
    @game.player_name = player_name
    @game.player_email = player_email

    # Set up boards
    player_board = GameEngine::BoardSetuper.new(Rails.root.join("config/game_config.json"), Rails.root.join("config/ship_blueprints.json")).setup
    opponent_board = GameEngine::Board.new(10, 10)
    @game.player_board = player_board
    @game.opponent_board = opponent_board

    # Call API with player_name and player_email, get session_id and x and y of first salvo
    player_name = game_params[:player_name]
    player_email = game_params[:player_email]
    # Do real call
    response = {"id" => "3309", "x" => 2, "y" => 6}
    @game.session_id = response["id"]

    #Place first salvo on my board
    player_board.place_salvo(response["x"], response["y"])

    if @game.save
      redirect_to game_path(@game)
    else
      render 'new'
    end
  end

  def show
    @game = Game.find(params[:id])
    @player_grid = GameEngine::Grid.new(@game.player_board).grid
    @opponent_grid = GameEngine::Grid.new(@game.opponent_board).grid
  end

  def edit
  end

  def update
  end

  def destroy
    @game = Game.find(params[:id]).destroy
    flash[:success] = "Game deleted."
    redirect_to games_path
  end

  private

    def game_params
      params.require(:game).permit(:player_name, :player_email)
    end

end
