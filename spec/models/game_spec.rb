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

end
