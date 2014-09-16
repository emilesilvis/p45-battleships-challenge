class Game < ActiveRecord::Base
  validates :player_name, presence: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :player_email, presence: true, format: { with: VALID_EMAIL_REGEX}
  validates :player_board, presence: true
  validates :opponent_board, presence: true

  serialize :player_board
  serialize :oppoenent_board
end
