class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :description
      t.datetime :created_on
      t.integer :user_id
      t.boolean :maintenance, default: false

      t.timestamps
    end
  end
end
