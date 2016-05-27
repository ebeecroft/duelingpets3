class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :vname
      t.datetime :joined_on

      t.timestamps
    end
  end
end
