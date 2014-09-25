require 'spec_helper'

describe Game do

  subject(:game) do
    player_board = GameEngine::Board.new(10, 10)
    opponent_board = GameEngine::Board.new(10, 10)
    Game.new(session_id: 1, player_name: 'Test Player', player_email: "player@test.com", player_board: player_board, opponent_board: opponent_board)
  end

  it { expect(game).to respond_to(:session_id) }
  it { expect(game).to respond_to(:player_name) }
  it { expect(game).to respond_to(:player_email) }
  it { expect(game).to respond_to(:player_board) }
  it { expect(game).to respond_to(:opponent_board) }

  context "when name is not present" do
    before { game.player_name = " " }
    it { expect(game).to_not be_valid }
  end

  context "when email is not present" do
    before { game.player_email = " " }
    it { expect(game).to_not be_valid }
  end

  context "when email is invalid" do
    before do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        game.player_email = invalid_address
      end
    end

    it "should be invalid" do
      expect(game).to_not be_valid
    end
  end

  describe "#register" do
    let(:player_name) { "Test Player" }
    let(:player_email) { "player@test.com" }

    before do
      VCR.use_cassette('register') do
        game.register(player_name, player_email)
      end
    end

    it "sets player's name" do
      expect(game.player_name).to eq player_name
    end

    it "sets player's email" do
      expect(game.player_email).to eq player_email
    end

    it "sets player's board" do
      expect(game.player_board).to_not be_nil
    end

    it "sets opponent's board" do
      expect(game.opponent_board).to_not be_nil
    end

    it "sets places opponent's first salvo on player's board" do
      expect(game.player_board.salvos).to_not be_empty
    end
  end

  describe "#battle" do
    context "when the player's salvo was a miss" do
      it "places a salvo on opponent's board" do
        VCR.use_cassette('nuke') do
          game.battle(1, 1)
        end
        expect(game.opponent_board.salvos.find { |salvo| salvo.x == 1 && salvo.y == 1 }).to be_a GameEngine::Atom
      end
    end

    context "when the player's salvo was a hit" do
      it "places a ship atom on opponent's board" do
        VCR.use_cassette('nuke_hit') do
          game.battle(1, 1)
        end
        expect(game.opponent_board.atoms.select { |atom| atom.x == 1 && atom.y == 1 }.any? { |atom| atom.manifestation.instance_of?(GameEngine::Ship) })
      end

      it "places a salvo on opponent's board" do
        expect(game.opponent_board.atoms.select { |salvo| salvo.x == 1 && salvo.y == 1 }.any? { |salvo| salvo.manifestation == :salvo })
      end
    end

    it "places a salvo on player's board" do
      VCR.use_cassette('nuke') do
        game.battle(1, 1)
        expect(game.player_board.salvos.find { |salvo| salvo.x == 2 && salvo.y == 7 }.manifestation).to eq :salvo
      end
    end

    context "when the player has sunk a ship" do
      it "adds the ship to the game's sunk ships" do
        VCR.use_cassette('nuke_sunk_ship') do
          game.battle(1, 1)
        end
        expect(game.sunk_ships).to_not be_empty
      end
    end

    context "when the player or opponent has lost" do
      it "sets the game as over" do
        VCR.use_cassette('nuke_lost') do
          game.battle(1, 1)
        end
        expect(game.over).to be_true
      end
    end

    context "when the player has won" do
      it "sets the prize" do
        VCR.use_cassette('nuke_won') do
          game.battle(1, 1)
        end
        expect(game.prize).to_not be_nil
      end
    end
  end

end
