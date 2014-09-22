require 'spec_helper'

describe GamesHelper do
  describe "#gravatar_for" do
    it "returns HTML element rendering the Gravatar" do
      expect(gravatar_for('test@tester.com', {:size => 40})).to be_a String
    end
  end

  describe "#render_cell" do
    before do
      @game = Game.create(session_id: 123, player_name: 'Test Player', player_email: 'player@test.com', player_board: GameEngine::Board.new(10, 10), opponent_board: GameEngine::Board.new(10, 10))
    end

    context "when the cell is an atom" do
      context "when the atom's ship type is carrier" do
        it "returns [c]" do
          ship = GameEngine::Ship.new('carrier', 2)
          @game.player_board.place_ship(ship, 1, 1, 1, 2)
          atom = @game.player_board.ships.first.atoms.first
          expect(render_cell(atom, 2, 2, false)).to eq "[c]"
        end
      end

      context "when the atom's ship type is battle ship" do
        it "returns [b]" do
          ship = GameEngine::Ship.new('battle ship', 2)
          @game.player_board.place_ship(ship, 1, 1, 1, 2)
          atom = @game.player_board.ships.first.atoms.first
          expect(render_cell(atom, 2, 2, false)).to eq "[b]"
        end
      end

      context "when the atom's ship type is battle ship" do
        it "returns [d]" do
          ship = GameEngine::Ship.new('destroyer', 2)
          @game.player_board.place_ship(ship, 1, 1, 1, 2)
          atom = @game.player_board.ships.first.atoms.first
          expect(render_cell(atom, 2, 2, false)).to eq "[d]"
        end
      end

      context "when the atom's ship type is submarine" do
        it "returns [s]" do
          ship = GameEngine::Ship.new('submarine', 2)
          @game.player_board.place_ship(ship, 1, 1, 1, 2)
          atom = @game.player_board.ships.first.atoms.first
          expect(render_cell(atom, 2, 2, false)).to eq "[s]"
        end
      end

      context "when the atom's ship type is patrol boat" do
        it "returns [s]" do
          ship = GameEngine::Ship.new('patrol boat', 2)
          @game.player_board.place_ship(ship, 1, 1, 1, 2)
          atom = @game.player_board.ships.first.atoms.first
          expect(render_cell(atom, 2, 2, false)).to eq "[p]"
        end
      end
    end

    context "when the cell is a salvo" do
      it "returns ///" do
        salvo = @game.player_board.place_salvo(1, 1)
        expect(render_cell(salvo, 1, 1, false)).to eq "///"
      end
    end

    context "when the cell is a hit" do
      it "returns [x]" do
        ship = GameEngine::Ship.new('Test Ship', 2)
        @game.player_board.place_ship(ship, 1, 1, 1, 2)
        @game.player_board.place_salvo(1, 1)
        hit = @game.player_board.hits.find { |hit| hit.x == 1 && hit.y == 1 }
        expect(render_cell(hit, 1, 1, false)).to eq "[x]"
      end
    end

    context "when the cell is nothing" do
      it "returns ooo" do
        expect(render_cell(nil, 1, 1, false)).to eq "ooo"
      end
    end

  end
end