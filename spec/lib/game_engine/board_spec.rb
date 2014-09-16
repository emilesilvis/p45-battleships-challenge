require 'spec_helper'

describe GameEngine::Board do
  before do
    @board = GameEngine::Board.new(10, 10)
    @ship = GameEngine::Ship.new('Test Ship', 2)
  end

  describe "#place_ship" do
    let(:start_x) { 1 }
    let(:start_y) { 2 }
    let(:end_x) { 1 }
    let(:end_y) { 3 }

    subject(:added_ship) { @board.place_ship(@ship, start_x, start_y, end_x, end_y) }

    it { expect(added_ship).to be_a GameEngine::Ship }

    it "Ship should have Atoms added to it corresponding to the start and end coordinates" do
      (start_x..end_x).each do |x|
        (start_y..end_y).each do |y|
          expect(added_ship.atoms.any? { |atom| atom.x == x && atom.y == y }).to be_true
        end
      end
    end
  end

  describe "#place_salvo" do
    subject(:added_salvo) { @board.place_salvo(GameEngine::Salvo.new, 1, 2) }

    it { expect(added_salvo).to be_a GameEngine::Salvo }

    it "Salvo should have correct coordinates set" do
      expect(added_salvo.x).to eq 1
      expect(added_salvo.y).to eq 2
    end

    before do
      @placed_ship = @board.place_ship(@ship, 1, 2, 1, 3)
    end

    describe "when coordinates do not overlap a Ship's Atom (a miss)" do
      it "should not modify Atom" do
        @board.place_salvo(GameEngine::Salvo.new, 4, 4)
        expect(@placed_ship.atoms.any? { |atom| atom.hit }).to be_false
      end
    end

    describe "when coordinates overlap a Ship's Atom (a hit)" do
      it "should set Atom as hit" do
        @board.place_salvo(GameEngine::Salvo.new, 1, 2)
        expect(@placed_ship.atoms.find { |atom| atom.x == 1 && atom.y == 2 }.hit).to be_true
      end
    end
  end

end