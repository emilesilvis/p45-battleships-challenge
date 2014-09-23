require_relative './atom.rb'

module GameEngine
  class AtomPlacer

    def initialize(board)
      @board = board
    end

    def place_atom(manifestation, x, y)
      validate_manifestation!(manifestation)
      validate_placement!(x,y)
      atom = create_atom(manifestation, x, y)
      @board.atoms << atom
      calculate_hits(manifestation, x, y)
      @board
    end

    private

    def validate_manifestation!(manifestation)
      fail "Manifestation must be Ship, :salvo or :hit" unless manifestation.instance_of?(GameEngine::Ship) || manifestation == :salvo || manifestation == :hit
    end

    def validate_placement!(x, y)
      fail "Coordinates must be inside the bounds of the board dimensions" if x > @board.width || y > @board.height
    end

    def create_atom(manifestation, x, y)
      atom = GameEngine::Atom.new(manifestation)
      atom.x = x
      atom.y = y
      atom
    end

    def calculate_hits(manifestation, x, y)
      if manifestation == :salvo
        if @board.atoms.find { |atom| atom.manifestation.instance_of?(GameEngine::Ship) && atom.x == x && atom.y == y}
          hit = GameEngine::Atom.new(:hit)
          hit.x = x
          hit.y = y
          @board.atoms << hit
        end
      end
    end

  end
end