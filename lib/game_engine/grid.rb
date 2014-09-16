module GameEngine
  class Grid

    def initialize(board)
      @grid = Array.new(board.width) { Array.new(board.height) }
      board.ships.each do |ship|
        ship.atoms.each do |atom|
          @grid[atom.x - 1][atom.y - 1] = atom
        end
      end
      board.salvos.each do |salvo|
        @grid[salvo.x - 1][salvo.y - 1] = salvo if @grid[salvo.x - 1][salvo.y - 1].nil?
      end
    end

    def data
      @grid
    end

  end
end