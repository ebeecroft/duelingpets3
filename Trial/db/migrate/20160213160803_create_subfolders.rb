class CreateSubfolders < ActiveRecord::Migration
  def change
    create_table :subfolders do |t|
      t.string :name
      t.text :description
      t.datetime :created_on
      t.integer :user_id
      t.integer :mainfolder_id
      t.boolean :collab_mode, default: false
      t.boolean :maintenance, default: false

      t.timestamps
    end
  end
end
