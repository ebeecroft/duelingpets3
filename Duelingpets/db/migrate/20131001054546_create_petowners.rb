class CreatePetowners < ActiveRecord::Migration
  def change
    create_table :petowners do |t|
      t.integer :user_id
      t.integer :pet_id
      t.string :pet_name
      t.datetime :adopted_on

      t.timestamps
    end
  end
end
