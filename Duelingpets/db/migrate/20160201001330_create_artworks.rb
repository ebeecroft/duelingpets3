class CreateArtworks < ActiveRecord::Migration
  def change
    create_table :artworks do |t|
      t.string :title
      t.text :description
      t.datetime :created_on
      t.integer :user_id
      t.integer :subfolder_id
      t.boolean :reviewed, default: false
      t.boolean :maintenance, default: false

      t.timestamps
    end
  end
end
