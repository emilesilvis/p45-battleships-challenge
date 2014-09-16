module GameEngine
  class PlacementValidator

    def validate_ship_placement!(board, ship, start_x, start_y, end_x, end_y)
      fail "Must be a Ship" unless ship.instance_of?(Ship)

      fail "Coordinates must be inside the bounds of the board dimensions" if start_x > board.width || start_y > board.height || end_x > board.width || end_y > board.height || start_x <= 0 || start_y <= 0 || end_x <= 0 || end_y <= 0

      proposed_x_length = ((start_x - end_x).abs + 1)
      proposed_y_lenth = ((start_y - end_y).abs + 1)
      proposed_ship_area = (proposed_x_length * proposed_y_lenth)
      fail "Coordinates must be inside the bounds of the ship dimensions" unless proposed_ship_area == ship.length && proposed_x_length != proposed_y_lenth

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
      space_occupied = projected_atoms.any? do |projected_atom|
        board.ships.any? {|ship| ship.atoms.any? {|atom| atom.x == projected_atom[0] && atom.y == projected_atom[1]}}
      end
      fail "Space already occupied" if space_occupied
    end

    def validate_salvo_placement!(board, salvo, x, y)
      fail "Must be a Salvo" unless salvo.instance_of?(Salvo)
      fail "Coordinates must be inside the bounds of the board dimensions" if x > board.width || y > board.height
    end

  end
end