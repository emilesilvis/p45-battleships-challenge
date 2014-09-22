class AddSunkShipsToGame < ActiveRecord::Migration
  def change
    add_column :games, :sunk_ships, :string
  end
end
