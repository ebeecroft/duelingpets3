class CreateEquips < ActiveRecord::Migration
  def change
    create_table :equips do |t|
      t.integer :petowner_id
      t.integer :inventory_id

      t.timestamps
    end
  end
end
