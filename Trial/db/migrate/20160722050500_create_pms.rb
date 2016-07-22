class CreatePms < ActiveRecord::Migration
  def change
    create_table :pms do |t|
      t.string :title
      t.text :description
      t.datetime :created_on
      t.integer :user_id
      t.integer :from_user_id
      t.boolean :maintenance, default: false

      t.timestamps
    end
  end
end
