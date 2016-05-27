class CreateSessionkeys < ActiveRecord::Migration
  def change
    create_table :sessionkeys do |t|
      t.string :remember_token
      t.datetime :expiretime
      t.integer :user_id

      t.timestamps
    end
  end
end
