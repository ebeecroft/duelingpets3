class CreateSounds < ActiveRecord::Migration
  def change
    create_table :sounds do |t|
      t.string :name
      t.text :description
      t.datetime :created_on
      t.integer :user_id
      t.integer :subsheet_id
      t.boolean :reviewed, default: false
      t.boolean :maintenance, default: false

      t.timestamps
    end
  end
end
