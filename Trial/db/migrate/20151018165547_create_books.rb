class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.datetime :created_on
      t.integer :sbook_id
      t.boolean :maintenance, default: false

      t.timestamps
    end
  end
end
