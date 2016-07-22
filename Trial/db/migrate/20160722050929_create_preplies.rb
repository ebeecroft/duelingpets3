class CreatePreplies < ActiveRecord::Migration
  def change
    create_table :preplies do |t|
      t.text :message
      t.datetime :created_on
      t.integer :pm_id
      t.integer :user_id
      t.boolean :maintenance, default: false

      t.timestamps
    end
  end
end
