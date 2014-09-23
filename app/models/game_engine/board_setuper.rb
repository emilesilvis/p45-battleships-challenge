require_relative './ship_factory.rb'
require_relative './board.rb'

module GameEngine
  class BoardSetuper

    def initialize(path_to_game_config, path_to_ship_blueprints)
      game_config_file = File.open(path_to_game_config)
      @game_config = JSON.parse(game_config_file.read)
      @ship_factory = GameEngine::ShipFactory.new(path_to_ship_blueprints)
    end

    def setup
      board = Board.new(@game_config['board']['width'], @game_config['board']['height'])
      ship_set = []
      @game_config['ships'].each do |ship|
        ship['quantity'].times do
          ship_set << @ship_factory.build(ship['type'])
        end
      end
      place_ships_randomly(ship_set, board)
      board
    end

    private

      def place_ships_randomly(ship_set, board)
        ship_placer = GameEngine::ShipPlacer.new(board)
        while !ship_set.empty?
          begin
            ship = ship_set.pop
            start_x = rand(@game_config['board']['width'])
            start_y = rand(@game_config['board']['height'])
            end_x = rand(@game_config['board']['width'])
            end_y = rand(@game_config['board']['height'])
            ship_placer.place_ship(ship, start_x, start_y, end_x, end_y)
          rescue
            ship_set.push(ship)
          end
        end
      end

  end
end