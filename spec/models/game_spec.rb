require 'spec_helper'

describe Game do

  before do
    player_board = GameEngine::Board.new(10, 10)
    opponent_board = GameEngine::Board.new(10, 10)
    @game = Game.new(session_id: 1, player_name: 'Test Player', player_email: "player@test.com", player_board: player_board, opponent_board: opponent_board)
  end

  it { expect(@game).to respond_to(:session_id) }
  it { expect(@game).to respond_to(:player_name) }
  it { expect(@game).to respond_to(:player_email) }
  it { expect(@game).to respond_to(:player_board) }
  it { expect(@game).to respond_to(:opponent_board) }

  describe "when name is not present" do
    before { @game.player_name = " " }
    it { expect(@game).to_not be_valid }
  end

  describe "when email is not present" do
    before { @game.player_email = " " }
    it { expect(@game).to_not be_valid }
  end

  describe "when email is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @game.player_email = invalid_address
        expect(@game).to_not be_valid
      end
    end
  end

  describe "#register" do

    let(:player_name) { "Test Player" }
    let(:player_email) { "player@test.com" }

    context "when there is an API error" do
      it "returns false" do
        VCR.use_cassette('register_error') do
          expect{ @game.register(player_name, player_email) }.to raise_error("API error: Some API error")
        end
      end
    end

    context "when there is no API error" do
      before do
        VCR.use_cassette('register') do
          @response = @game.register(player_name, player_email)
        end
      end

      it "returns the game" do
        expect(@response).to be_a Game
      end

      it "sets player's name" do
        expect(@response.player_name).to eq player_name
      end

      it "sets player's email" do
        expect(@response.player_email).to eq player_email
      end

      it "sets player's board" do
        expect(@response.player_board).to_not be_nil
      end

      it "sets opponent's board" do
        expect(@response.opponent_board).to_not be_nil
      end

      it "sets places opponent's first salvo on player's board" do
        expect(@response.player_board.salvos).to_not be_empty
      end

    end
  end

  describe "#battle" do

    let(:x) { 1 }
    let(:y) { 1 }

    context "when there is an API error" do
      it "returns false" do
        VCR.use_cassette('nuke_error') do
          expect{ @game.battle(x, y) }.to raise_error("API error: Some API error")
        end
      end
    end

    context "when there is no API error" do
      before do
        VCR.use_cassette('nuke') do
          @response = @game.battle(1, 1)
        end
      end

      it "return the game" do
        expect(@response).to be_a Game
      end

      it "places a salvo on opponent's board" do
        expect(@response.opponent_board.salvos).to_not be_empty
      end

      it "places a salvo on player's board" do
        ap @response.player_board
        expect(@response.player_board.salvos).to_not be_empty
      end
    end
  end

end
