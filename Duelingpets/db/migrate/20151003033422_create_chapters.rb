class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.string :title
      t.text :story
      t.datetime :created_on
      t.integer :user_id
      t.integer :book_id
      t.integer :gchapter_id
      t.boolean :reviewed, default: false
      t.boolean :maintenance, default: false

      t.timestamps
    end
  end
end
