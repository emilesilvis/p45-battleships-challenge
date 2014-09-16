module GameEngine
  class Atom

    attr_reader :x, :y, :ship

    def initialize(x, y, ship)
      @x = x
      @y = y
      @ship = ship
    end

  end
end