class AddStatsToFights < ActiveRecord::Migration
  def change
    add_column :fights, :pet_hp, :integer
    add_column :fights, :level, :integer
    add_column :fights, :exp, :integer
    add_column :fights, :hp, :integer
    add_column :fights, :atk, :integer
    add_column :fights, :def, :integer
    add_column :fights, :spd, :integer
  end
end
