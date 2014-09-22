class Game < ActiveRecord::Base
  validates :player_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :player_email, presence: true, format: { with: VALID_EMAIL_REGEX}

  serialize :player_board
  serialize :opponent_board

  def register(name, email)
    api_response = api_client.register(name, email)
    check_api_response!(api_response)
    self.player_name = name
    self.player_email = email
    self.player_board = GameEngine::BoardSetuper.new(Rails.root.join("config/game_config.json"), Rails.root.join("config/ship_blueprints.json")).setup
    self.opponent_board = GameEngine::Board.new(10, 10)
    self.session_id = api_response[:id]
    self.player_board.place_salvo(api_response[:x], api_response[:y])
    self.save
    self
  end

  def battle(x, y)
    api_response = api_client.nuke(self.session_id, x, y)
    check_api_response!(api_response)
    self.opponent_board.place_salvo(x.to_i, y.to_i)
    self.player_board.place_salvo(api_response[:x], api_response[:y])
    self.save
    self

    # Check for game_status in response["game_status"]
    # Check for prize in response["prize"]
    # Check for sunk in response["sunk"]

  end

  private
    def api_client
      Api::Client.new('http://battle.platform45.com')
    end

    def check_api_response!(api_response)
      fail "API error: #{api_response[:error]}" if api_response[:error]
    end

end
