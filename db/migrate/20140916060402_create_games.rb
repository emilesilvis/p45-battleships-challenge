class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :session_id
      t.string :player_name
      t.string :player_email

      t.timestamps
    end
  end
end
