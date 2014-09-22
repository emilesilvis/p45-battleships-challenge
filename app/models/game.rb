class Game < ActiveRecord::Base

  validates :player_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :player_email, presence: true, format: { with: VALID_EMAIL_REGEX}

  serialize :player_board
  serialize :opponent_board
  serialize :sunk_ships

  def register(name, email)
    response = api_client.register(name, email)
    save_game_details(name, email, response)
    initialise_first_turn(name, email, response)
    self.save
    self
  end

  def battle(x, y)
    response = api_client.nuke(session_id, x, y)
    place_salvos(x, y, response)
    update_sunk_ships(response)
    update_victory_status(response)
    self.save
    self
  end

  private

    def api_client
      Api::Client.new('http://battle.platform45.com')
    end

    def save_game_details(name, email, response)
      self.player_name = name
      self.player_email = email
      self.session_id = response[:id]
    end

    def initialise_first_turn(name, email, response)
      setup_boards
      self.player_board.place_salvo(response[:x], response[:y])
    end

    def setup_boards
      self.player_board = GameEngine::BoardSetuper.new(Rails.root.join("config/game_config.json"), Rails.root.join("config/ship_blueprints.json")).setup
      self.opponent_board = GameEngine::Board.new(10, 10)
    end

    def place_salvos(x, y, response)
      self.opponent_board.place_ship(GameEngine::Ship.new('Unidentified', 1), x.to_i, y.to_i, x.to_i, y.to_i) if response[:status] == "hit"
      self.opponent_board.place_salvo(x.to_i, y.to_i) if response[:status] == "miss"
      self.player_board.place_salvo(response[:x], response[:y])
    end

    def update_sunk_ships(response)
      if response[:sunk]
        if self.sunk_ships
          self.sunk_ships << response[:sunk]
        else
          self.sunk_ships = [response[:sunk]]
        end
      end
    end

    def update_victory_status(response)
      self.over = true if response[:game_status] == "lost" || response[:prize]
      self.prize = response[:prize] if response[:prize]
    end

end
