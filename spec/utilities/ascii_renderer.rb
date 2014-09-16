# A small class to help me visualise the grid during development
require_relative '../../lib/game_engine/grid.rb'

class ASCIIRenderer
  def initialize(board)
    @board = board
  end

  def render
    grid = GameEngine::Grid.new(@board).data.transpose

    board_string = ""

    column_header = "   "
    grid.first.each_with_index { |column, column_index| column_header += (column_index + 1).to_s.center(4) }
    column_header += "\n"
    board_string += column_header

    header_divider = ""
    header_divider += '---' * (grid.first.size + 4) + "\n"
    board_string += header_divider


    grid.each_with_index do |row, row_index|
      board_string += (row_index + 1).to_s.ljust(2) + "|"
      row.each_with_index do |column, column_index|
        if column.class.to_s == "GameEngine::Atom"
          if column.hit
            board_string += "[X] " if column.hit
          else
            board_string += "[c] " if column.ship.type == 'carrier'
            board_string += "[b] " if column.ship.type == 'battle ship'
            board_string += "[d] " if column.ship.type == 'destroyer'
            board_string += "[s] " if column.ship.type == 'submarine'
            board_string += "[p] " if column.ship.type == 'patrol boat'
          end
        elsif column.class.to_s == "GameEngine::Salvo"
          board_string += "/// "
        else
          board_string += "ooo " if column.nil?
        end
      end
      board_string += "\n"
    end
    puts board_string
  end

end