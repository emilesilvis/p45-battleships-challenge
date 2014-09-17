require_relative './placement_validator.rb'
require_relative './atom.rb'

module GameEngine
  class Board

    attr_reader :width, :height, :ships, :salvos, :hits

    def initialize(width, height)
      @width = width
      @height = height
      @ships = []
      @salvos = []
      @hits = []
    end

    def place_ship(ship, start_x, start_y, end_x, end_y)
      PlacementValidator.new.validate_ship_placement!(self, ship, start_x, start_y, end_x, end_y)
      x_length = [start_x, end_x].sort
      x_range = Range.new(x_length.first, x_length.last)
      y_length = [start_y, end_y].sort
      y_range = Range.new(y_length.first, y_length.last)
      x_range.each do |x|
        y_range.each do |y|
          ship.atoms << Atom.new(x, y, ship)
        end
      end
      @ships << ship
      ship
    end

    def place_salvo(x, y)
      salvo = GameEngine::Salvo.new
      PlacementValidator.new.validate_salvo_placement!(self, salvo, x, y)
      salvo.x = x
      salvo.y = y
      @salvos << salvo
      atom = @ships.collect { |ship| ship.atoms }.flatten.find { |atom| atom.x == x && atom.y == y}
      @hits << GameEngine::Hit.new(x, y) unless atom.nil?
      salvo
    end

  end
end