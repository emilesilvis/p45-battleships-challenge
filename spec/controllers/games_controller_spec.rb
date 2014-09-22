require 'spec_helper'

describe GamesController do

  describe "GET #index" do
    before do
      @game = Game.create(session_id: 123, player_name: 'Test Player', player_email: 'player@test.com', player_board: GameEngine::Board.new(10, 10), opponent_board: GameEngine::Board.new(10, 10))
      get :index
    end

    it "has a collection of games" do
      expect(assigns(:games)).to include @game
    end

    it "renders index view" do
      expect(response).to render_template( 'index' )
    end
  end

  describe "GET #new" do
    before do
      get :new
    end
    it "makes a new game" do
      expect(assigns(:game)).to be_a Game
    end
    it "renders new view" do
      expect(response).to render_template( 'new' )
    end
  end

  describe "POST #create" do
    context "with API error" do
      it "renders error view" do
        VCR.use_cassette('register_error') do
          post :create, game: {player_name: 'Test Player', player_email: 'player@test.com'}
          expect(response).to render_template( 'error' )
        end
      end
    end

    context "with invalid paramaters" do
      before do
        VCR.use_cassette('register') do
          post :create, game: {player_name: 'Test Player'}
        end
      end

      it "is not valid" do
        expect(assigns(:game)).to_not be_valid
      end

      it "redirects to new" do
        expect(response).to render_template( 'new' )
      end
    end

    context "with valid parameters" do
      before do
        VCR.use_cassette('register') do
          post :create, game: {player_name: 'Test Player', player_email: 'player@test.com'}
        end
      end

      it "is valid" do
        expect(assigns(:game)).to be_valid
      end

      it "redirects to show" do
        expect(response).to redirect_to( game_path(assigns(:game)) )
      end
    end
  end

  describe "GET #show" do
    before do
      @game = Game.create(session_id: 123, player_name: 'Test Player', player_email: 'player@test.com', player_board: GameEngine::Board.new(10, 10), opponent_board: GameEngine::Board.new(10, 10))
      get :show, {id: @game.id}
    end

    it "has a game" do
      expect(assigns(:game)).to_not be_nil
    end

    it "has a player grid" do
      expect(assigns(:player_grid)).to_not be_nil
    end

    it "has an opponent_grid" do
      expect(assigns(:opponent_grid)).to_not be_nil
    end

    it "renders show view" do
      expect(response).to render_template( 'show' )
    end
  end

  describe "PATCH #update" do
    before do
      @game = Game.create(session_id: 123, player_name: 'Test Player', player_email: 'player@test.com', player_board: GameEngine::Board.new(10, 10), opponent_board: GameEngine::Board.new(10, 10))
        VCR.use_cassette('nuke') do
          patch :update, {id: @game.id, x: 1, y: 1}
        end
    end

    it "has a game" do
      expect(assigns(:game)).to_not be_nil
    end

    it "redirects to show" do
      expect(response).to redirect_to( game_path(@game.id) )
    end

    context "when there is an API error" do
      it "renders error view" do
       VCR.use_cassette('nuke_error') do
          patch :update, {id: @game.id, x: 1, y: 1}
          expect(response).to render_template( 'error' )
        end
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      VCR.use_cassette('register') do
        post :create, game: {player_name: 'Test Player', player_email: 'player@test.com'}
      end
      @game = assigns(:game)
      delete :destroy, {id: @game.id}
    end

    it "destroys game" do
      expect{ Game.find(@game.id) }.to raise_error("Couldn't find Game with id=#{@game.id}")
    end

    it "creates a flash message" do
      expect(flash[:success]).to eq "Game deleted!"
    end

    it "redirects to index" do
      expect(response).to redirect_to( games_path )
    end
  end
end
