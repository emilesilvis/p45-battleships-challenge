class Game < ActiveRecord::Base
  serialize :player_board
  serialize :oppoenent_board
end
