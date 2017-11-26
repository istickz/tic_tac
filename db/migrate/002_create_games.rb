class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games, force: true do |t|
      t.string :inline_message_id
      t.string :chat_instance
      t.jsonb :data, default: {}
    end

    add_index :games, [:chat_instance, :inline_message_id]
  end
end
