class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, force: true do |t|
      t.integer :uid
      t.boolean  :is_bot
      t.string  :first_name
      t.string  :last_name
      t.string :username
      t.string :language_code
    end

    add_index :users, :uid
  end
end
