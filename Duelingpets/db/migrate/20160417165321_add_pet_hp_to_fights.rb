class AddPetHpToFights < ActiveRecord::Migration
  def change
    add_column :fights, :pet_hp, :integer
  end
end
