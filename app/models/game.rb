class Game < ActiveRecord::Base
  validates :player_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :player_email, presence: true, format: { with: VALID_EMAIL_REGEX}
  #validates :player_board, presence: true
  #validates :opponent_board, presence: true

  serialize :player_board
  serialize :opponent_board

  def register(name, email)
    self.player_name = name
    self.player_email = email

    self.player_board = GameEngine::BoardSetuper.new(Rails.root.join("config/game_config.json"), Rails.root.join("config/ship_blueprints.json")).setup
    self.opponent_board = GameEngine::Board.new(10, 10)

    # Call API with player_name and player_email, get session_id and x and y of first salvo
    # Do real call
    response = {"id" => "3309", "x" => 2, "y" => 6}
    self.session_id = response["id"]

    self.player_board.place_salvo(response["x"], response["y"])

    self
  end

  def battle(x, y)
    # Call API with x and y of salvo
    # Do real call
    response = {"status" => "miss", "x" => 3, "y" => 7}

    # Check for error in response["error"]
    # Check for game_status in response["game_status"]
    # Check for prize in response["prize"]
    # Check for sunk in response["sunk"]

    # Add a Salvo or Hit to opponent board
    self.opponent_board.place_salvo(x.to_i, y.to_i)

    # Add a Salvo or Hit to player board
    self.player_board.place_salvo(response["x"], response["x"])

    self
  end

end
