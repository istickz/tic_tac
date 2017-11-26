class CreateGameResults < ActiveRecord::Migration[5.1]
  def change
    create_table :game_results, force: true do |t|
      t.integer :game_id
      t.integer :user_id
      t.boolean :winner, default: false
    end

    add_index :game_results, [:game_id, :user_id]
  end
end
