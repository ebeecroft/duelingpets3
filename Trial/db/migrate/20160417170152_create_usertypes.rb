class CreateUsertypes < ActiveRecord::Migration
  def change
    create_table :usertypes do |t|
      t.integer :user_id
      t.string :privilege

      t.timestamps
    end
  end
end
