class CreateMainfolders < ActiveRecord::Migration
  def change
    create_table :mainfolders do |t|
      t.string :name
      t.text :description
      t.datetime :created_on
      t.integer :user_id
      t.boolean :maintenance, default: false

      t.timestamps
    end
  end
end
