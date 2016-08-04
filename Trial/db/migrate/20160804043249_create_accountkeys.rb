class CreateAccountkeys < ActiveRecord::Migration
  def change
    create_table :accountkeys do |t|
      t.integer :user_id
      t.string :token
      t.boolean :activated, default: false

      t.timestamps
    end
  end
end
