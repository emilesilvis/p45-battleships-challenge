class AddPlayerBoardToGame < ActiveRecord::Migration
  def change
    add_column :games, :player_board, :string
  end
end
