class CreatePouches < ActiveRecord::Migration
  def change
    create_table :pouches do |t|
      t.integer :amount, default: 200
      t.integer :user_id

      t.timestamps
    end
    add_index :pouches, :user_id, unique: true
  end
end
