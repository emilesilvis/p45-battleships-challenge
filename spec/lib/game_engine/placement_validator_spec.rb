require 'spec_helper'

describe GameEngine::PlacementValidator do
  let(:board) { GameEngine::Board.new(10, 10) }
  let(:ship) { GameEngine::Ship.new('Test Ship', 2) }

  subject(:placement_validator) { GameEngine::PlacementValidator.new }

  describe "#validate_ship_placement!" do
    context "with invalid ship" do
      it { expect{ placement_validator.validate_ship_placement!(board, 'invalid ship', 1, 2, 1, 2) }.to raise_error("Must be a Ship") }
    end

    context "with coordinates that are outside the board dimensions" do
      it { expect{ placement_validator.validate_ship_placement!(board, ship, 10, 11, 11, 11) }.to raise_error("Coordinates must be inside the bounds of the board dimensions") }
      it { expect{ placement_validator.validate_ship_placement!(board, ship, 0, 1, 1, 1) }.to raise_error("Coordinates must be inside the bounds of the board dimensions") }
      it { expect{ placement_validator.validate_ship_placement!(board, ship, -1, 0, 0, 0) }.to raise_error("Coordinates must be inside the bounds of the board dimensions") }
    end

    context "with coordinates that are outside the ship dimensions" do
      it do
        expect{ placement_validator.validate_ship_placement!(board, ship, 1, 2, 1, 2) }.to raise_error("Coordinates must be inside the bounds of the ship dimensions")
        expect{ placement_validator.validate_ship_placement!(board, ship, 1, 2, 1, 4) }.to raise_error("Coordinates must be inside the bounds of the ship dimensions")
        expect{ placement_validator.validate_ship_placement!(board, ship, 1, 2, 2, 3) }.to raise_error("Coordinates must be inside the bounds of the ship dimensions")
        ship = GameEngine::Ship.new('Test Ship', 4)
        expect{ placement_validator.validate_ship_placement!(board, ship, 6, 7, 5, 8) }.to raise_error("Coordinates must be inside the bounds of the ship dimensions")
      end
    end

    context "with coordinates that are already occupied" do
      it do
        two_length = GameEngine::Ship.new('Two', 2)
        four_length = GameEngine::Ship.new('Four', 4)
        board.place_ship(four_length, 1, 9, 1, 6)
        expect{ board.place_ship(two_length, 1, 7, 1, 8) }.to raise_error("Space already occupied")
      end
    end
  end

  describe "#validate_salvo_placement!" do
    context "with invalid salvo" do
      it { expect{ placement_validator.validate_salvo_placement!(board, 'invalid salvo', 1, 2) }.to raise_error("Must be a Salvo") }
    end
    context "with coordinates that are outside the board dimensions" do
      it { expect{ placement_validator.validate_salvo_placement!(board, GameEngine::Salvo.new, 11, 11) }.to raise_error("Coordinates must be inside the bounds of the board dimensions") }
    end
  end
end