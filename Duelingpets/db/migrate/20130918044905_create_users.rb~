class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :vname
      t.string :password
      t.string :confirm
      t.integer :money
      t.boolean :admin
      t.date :joined_on
      t.boolean :maintenance

      t.timestamps
    end
  end
end
