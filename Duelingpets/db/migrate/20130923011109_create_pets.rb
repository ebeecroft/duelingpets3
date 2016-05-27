class CreatePets < ActiveRecord::Migration
  def change
    create_table :pets do |t|
      t.string :species_name
      t.text :description
      t.datetime :created_on

      t.timestamps
    end
  end
end
