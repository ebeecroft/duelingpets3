class CreateSubsheets < ActiveRecord::Migration
  def change
    create_table :subsheets do |t|
      t.string :name
      t.text :description
      t.datetime :created_on
      t.integer :user_id
      t.integer :mainsheet_id
      t.boolean :collab_mode, default: false
      t.boolean :maintenance, default: false

      t.timestamps
    end
  end
end
