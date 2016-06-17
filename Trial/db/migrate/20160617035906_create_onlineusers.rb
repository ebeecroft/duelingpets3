class CreateOnlineusers < ActiveRecord::Migration
  def change
    create_table :onlineusers do |t|
      t.datetime :signed_in_at
      t.datetime :last_visited
      t.datetime :signed_out_at
      t.integer :user_id

      t.timestamps
    end
  end
end
