require 'spec_helper'

describe GameEngine::ShipPlacer do
  before do
    @board = GameEngine::Board.new(10, 10)
    @ship = GameEngine::Ship.new('Test Ship', 2)
  end

  subject(:ship_placer) { GameEngine::ShipPlacer.new(@board) }

  describe "#place_ship" do
    let(:start_x) { 1 }
    let(:start_y) { 2 }
    let(:end_x) { 1 }
    let(:end_y) { 3 }

    it "Ship should have Atoms added to it corresponding to the start and end coordinates" do
      board_with_placed_ships = ship_placer.place_ship(@ship, start_x, start_y, end_x, end_y)
      (start_x..end_x).each do |x|
        (start_y..end_y).each do |y|
          expect(board_with_placed_ships.ships.first.atoms.any? { |atom| atom.x == x && atom.y == y }).to be_true
        end
      end
    end

    it "Board should have Atoms added to it corresponding to the start and end coordinates" do
      board_with_placed_ships = ship_placer.place_ship(@ship, start_x, start_y, end_x, end_y)
      (start_x..end_x).each do |x|
        (start_y..end_y).each do |y|
          expect(@board.atoms.any? { |atom| atom.x == x && atom.y == y }).to be_true
        end
      end
    end

    context "with coordinates that are outside the board dimensions" do
      it { expect{ ship_placer.place_ship(@ship, 10, 11, 11, 11) }.to raise_error("Coordinates must be inside the bounds of the board dimensions") }
      it { expect{ ship_placer.place_ship(@ship, 0, 1, 1, 1) }.to raise_error("Coordinates must be inside the bounds of the board dimensions") }
      it { expect{ ship_placer.place_ship(@ship, -1, 0, 0, 0) }.to raise_error("Coordinates must be inside the bounds of the board dimensions") }
    end

    context "with coordinates that are outside the ship dimensions" do
      it do
        expect{ ship_placer.place_ship(@ship, 1, 2, 1, 2) }.to raise_error("Coordinates must be inside the bounds of the ship dimensions")
        expect{ ship_placer.place_ship(@ship, 1, 2, 1, 4) }.to raise_error("Coordinates must be inside the bounds of the ship dimensions")
        expect{ ship_placer.place_ship(@ship, 1, 2, 2, 3) }.to raise_error("Coordinates must be inside the bounds of the ship dimensions")
        ship = GameEngine::Ship.new('Test Ship', 4)
        expect{ ship_placer.place_ship(@ship, 6, 7, 5, 8) }.to raise_error("Coordinates must be inside the bounds of the ship dimensions")
      end
    end

    context "with coordinates that are already occupied" do
      it do
        two_length = GameEngine::Ship.new('Two', 2)
        four_length = GameEngine::Ship.new('Four', 4)
        ship_placer = GameEngine::ShipPlacer.new(@board)
        ship_placer.place_ship(four_length, 1, 9, 1, 6)
        expect{ ship_placer.place_ship(two_length, 1, 7, 1, 8) }.to raise_error("Space already occupied")
      end
    end

  end

end