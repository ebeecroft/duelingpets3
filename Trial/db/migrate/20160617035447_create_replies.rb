class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.text :message
      t.integer :blog_id
      t.integer :user_id
      t.datetime :created_on
      t.boolean :maintenance, default: false

      t.timestamps
    end
  end
end
