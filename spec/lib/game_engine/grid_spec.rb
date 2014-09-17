require 'spec_helper'

describe GameEngine::Grid do

  describe "#data" do
    before do
      @ship = GameEngine::Ship.new('Test Ship', 2)
      @board = GameEngine::Board.new(10, 10)
      @board.place_ship(@ship, 1, 2, 1, 3)
      @board.place_salvo(4, 4)
      @board.place_salvo(1, 2)
      @grid = GameEngine::Grid.new(@board).data
    end


    it "renders Atoms" do
      expect(@grid[0][2]).to be_an GameEngine::Atom
    end

    it "renders Salvos" do
      expect(@grid[3][3]).to be_an GameEngine::Salvo
    end

    it "renders Hits" do
      expect(@grid[0][1]).to be_an GameEngine::Hit
    end

  end

end