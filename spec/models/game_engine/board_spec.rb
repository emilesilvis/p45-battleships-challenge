require 'spec_helper'

describe GameEngine::Board do
  before do
    @board = GameEngine::Board.new(10, 10)
    @ship = GameEngine::Ship.new('Test Ship', 2)
    @ship_placer = GameEngine::ShipPlacer.new(@board)
  end

end