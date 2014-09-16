module GameEngine
  class Atom

    attr_reader :x, :y, :ship
    attr_accessor :hit

    def initialize(x, y, ship)
      @x = x
      @y = y
      @ship = ship
      @hit = false
    end

  end
end