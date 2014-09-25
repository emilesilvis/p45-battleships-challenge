module GameEngine
  class Grid

    def initialize(board)
      @board = board
    end

    def grid
      @grid = Array.new(@board.width) { Array.new(@board.height) }
      @board.ships.each do |ship|
        ship.atoms.each do |atom|
          @grid[atom.x - 1][atom.y - 1] = atom
        end
      end
      @board.salvos.each do |salvo|
        @grid[salvo.x - 1][salvo.y - 1] = salvo
      end
      @board.hits.each do |hit|
        @grid[hit.x - 1][hit.y - 1] = hit
      end
      @grid
    end
  end
end