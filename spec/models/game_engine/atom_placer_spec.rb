require 'spec_helper'

describe GameEngine::AtomPlacer do
  before do
    @board = GameEngine::Board.new(10, 10)
    @ship = GameEngine::Ship.new('Test Ship', 2)
    @ship_placer = GameEngine::ShipPlacer.new(@board)
    @atom_placer = GameEngine::AtomPlacer.new(@board)
  end

  describe "#place_atom" do

    it "fails when it's manifestation is not a Ship, :salvo or :hit" do
      expect{ @atom_placer.place_atom(:invalid_manifestation, 1, 1) }.to raise_error "Manifestation must be Ship, :salvo or :hit"
    end

    context "with coordinates that are outside the board dimensions" do
      it { expect{ @atom_placer.place_atom(:salvo, 11, 11) }.to raise_error("Coordinates must be inside the bounds of the board dimensions") }
    end

    context "when ship" do
      it "adds an atom that manifests as a Ship to the board" do
        ship = GameEngine::Ship.new("Test Ship", 1)
        board_with_placed_atom = @atom_placer.place_atom(ship, 1, 1)
        expect(board_with_placed_atom.atoms.find {|atom| atom.x == 1 && atom.y == 1}.manifestation ).to be_a GameEngine::Ship
      end
    end

    context "when salvo" do
      it "adds an atom that manifests as a salvo to the board" do
        board_with_placed_atom = @atom_placer.place_atom(:salvo, 1, 1)
        expect(board_with_placed_atom.atoms.find {|atom| atom.x == 1 && atom.y == 1}.manifestation ).to eq :salvo
      end
    end

    context "when hit" do
      it "adds an atom that manifests as a hit to the board" do
        board_with_placed_atom = @atom_placer.place_atom(:hit, 1, 1)
        expect(board_with_placed_atom.atoms.find {|atom| atom.x == 1 && atom.y == 1}.manifestation ).to eq :hit
      end
    end

    describe "when a salvo and ship do not overlap" do
      it "does not add an atom that manifests as a hit to the board" do
        ship = GameEngine::Ship.new("Test Ship", 1)
        board_with_placed_atom = @atom_placer.place_atom(ship, 1, 1)
        board_with_placed_atom = @atom_placer.place_atom(:salvo, 2, 2)
        expect(board_with_placed_atom.hits.any? { |hit| hit }).to be_false
      end
    end

    describe "when a salvo and ship overlaps" do
      it "adds an atom that manifests as a hit to the board" do
        ship = GameEngine::Ship.new("Test Ship", 1)
        @atom_placer.place_atom(ship, 1, 1)
        @atom_placer.place_atom(:salvo, 1, 1)
        board_with_placed_atom = @atom_placer.place_atom(:salvo, 1, 1)
        expect(board_with_placed_atom.hits.any? { |hit| hit }).to be_true
      end
    end

  end

end