require 'spec_helper'

describe GamesController do
  describe "GET #index" do
    before do
      @game = Game.create(session_id: 123, player_name: 'Test Player', player_email: 'player@test.com', player_board: GameEngine::Board.new(10, 10), opponent_board: GameEngine::Board.new(10, 10))
    end

    it "shows games" do
      get :index
      expect(assigns(:games)).to include @game
    end
  end

  describe "POST #create" do
    context "with invalid paramaters" do
      before do
        post :create, game: {player_name: 'Test Player'}
      end

      it "is not valid" do
        game = assigns(:game)
        expect(assigns(:game)).to_not be_valid
      end

      it "redirects to #new" do
        game = assigns(:game)
        expect(response).to render_template( "new" )
      end
    end

    context "with valid parameters" do
      before do
        post :create, game: {player_name: 'Test Player', player_email: 'player@test.com'}
      end

      it "is valid" do
        game = assigns(:game)
        expect(assigns(:game)).to be_valid
      end

      it "redirects to #show" do
        game = assigns(:game)
        expect(response).to redirect_to( game_path(game) )
      end
    end
  end

  describe "GET #show" do
    before do
      @game = Game.create(session_id: 123, player_name: 'Test Player', player_email: 'player@test.com', player_board: GameEngine::Board.new(10, 10), opponent_board: GameEngine::Board.new(10, 10))
    end

    it "shows game" do
      get :show
      expect(assigns(:player_grid)).to_not be_nil
      expect(assigns(:opponent_grid)).to_not be_nil
    end
  end

  describe "DELETE #destroy" do
    before do
      post :create, game: {player_name: 'Test Player', player_email: 'player@test.com'}
      @game = assigns(:game)
    end
    it "is destroyed" do
      delete :destroy, {id: @game.id}
      expect{ Game.find(@game.id) }.to raise_error("Couldn't find Game with id=#{@game.id}")
    end
  end
end
