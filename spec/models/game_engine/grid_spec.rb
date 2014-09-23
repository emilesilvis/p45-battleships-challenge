require 'spec_helper'

describe GameEngine::Grid do

  describe "#data" do
    before do
      @ship = GameEngine::Ship.new('Test Ship', 2)
      @board = GameEngine::Board.new(10, 10)
      ship_placer = GameEngine::ShipPlacer.new(@board)
      ship_placer.place_ship(@ship, 1, 2, 1, 3)
      atom_placer = GameEngine::AtomPlacer.new(@board)
      @board = atom_placer.place_atom(:salvo, 4, 4)
      @board = atom_placer.place_atom(:salvo, 1, 2)
      @grid = GameEngine::Grid.new(@board).grid
    end

    it "returns a grid with atoms" do
      expect(@grid[0][2]).to be_an GameEngine::Atom
    end

    context "when there is a ship in the grid" do
      it "the atom manifests as a ship" do
        expect(@grid[0][2].manifestation).to be_a GameEngine::Ship
      end
    end

    context "when there is a salvo in the grid" do
      it "the atom manifests as a salvo" do
        expect(@grid[3][3].manifestation).to be :salvo
      end
    end

    context "when there is a hit in the grid" do
      it "the atom manifests as a hit" do
        expect(@grid[0][1].manifestation).to be :hit
      end
    end
  end

end