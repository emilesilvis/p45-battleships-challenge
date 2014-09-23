module GameEngine
  class ShipPlacer

    def initialize(board)
      @board = board
    end

    def place_ship(ship, start_x, start_y, end_x, end_y)
      validate_type!(ship)
      validate_placement!(ship, start_x, start_y, end_x, end_y)
      create_ship_atoms(ship, start_x, start_y, end_x, end_y)
      @board.ships << ship
      @board
    end

    private

    def validate_type!(ship)
       fail "Must be a Ship" unless ship.instance_of?(GameEngine::Ship)
    end

    def validate_placement!(ship, start_x, start_y, end_x, end_y)
      fail "Coordinates must be inside the bounds of the board dimensions" if outside_board?(@board, start_x, start_y, end_x, end_y)
      fail "Coordinates must be inside the bounds of the ship dimensions" if invalid_ship_dimensions?(ship, start_x, start_y, end_x, end_y)
      fail "Space already occupied" if space_occupied?(ship, start_x, start_y, end_x, end_y)
    end

    def create_ship_atoms(ship, start_x, start_y, end_x, end_y)
      project_atoms(start_x, start_y, end_x, end_y).each do |projected_atom|
         atom = GameEngine::Atom.new(ship)
         atom.x = projected_atom.first
         atom.y = projected_atom.last
         ship.atoms << atom
         @board.atoms << atom
      end
    end

    def outside_board?(board, start_x, start_y, end_x, end_y)
      start_x > board.width || start_y > board.height || end_x > board.width || end_y > board.height || start_x <= 0 || start_y <= 0 || end_x <= 0 || end_y <= 0
    end

    def invalid_ship_dimensions?(ship, start_x, start_y, end_x, end_y)
      proposed_x_length = ((start_x - end_x).abs + 1)
      proposed_y_length = ((start_y - end_y).abs + 1)
      proposed_ship_area = (proposed_x_length * proposed_y_length)
      proposed_ship_area != ship.length || proposed_x_length == proposed_y_length && proposed_ship_area != 1
    end

    def space_occupied?(ship, start_x, start_y, end_x, end_y)
      project_atoms(start_x, start_y, end_x, end_y).any? do |projected_atom|
        @board.ships.any? { |ship| ship.atoms.any? { |atom| atom.x == projected_atom.first && atom.y == projected_atom.last } }
      end
    end

    def project_atoms(start_x, start_y, end_x, end_y)
      x_length = [start_x, end_x].sort
      x_range = Range.new(x_length.first, x_length.last)
      y_length = [start_y, end_y].sort
      y_range = Range.new(y_length.first, y_length.last)
      projected_atoms = []
      x_range.each do |x|
        y_range.each do |y|
          projected_atoms << [x, y]
        end
      end
      projected_atoms
    end

  end
end