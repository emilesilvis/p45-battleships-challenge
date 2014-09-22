class AddOverToGame < ActiveRecord::Migration
  def change
    add_column :games, :over, :boolean
  end
end
