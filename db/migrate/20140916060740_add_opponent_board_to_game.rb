class AddOpponentBoardToGame < ActiveRecord::Migration
  def change
    add_column :games, :opponent_board, :string
  end
end
