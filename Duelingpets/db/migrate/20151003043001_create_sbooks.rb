class CreateSbooks < ActiveRecord::Migration
  def change
    create_table :sbooks do |t|
      t.string :name
      t.datetime :created_on
      t.integer :user_id
      t.boolean :series_open, default: false
      t.boolean :maintenance, default: false

      t.timestamps
    end
  end
end
