class AddInfoToFights < ActiveRecord::Migration
  def change
    add_column :fights, :round, :integer, default: 1
    add_column :fights, :pdamage, :integer
    add_column :fights, :mdamage, :integer
    add_column :fights, :coins, :integer
    add_column :fights, :mhp, :integer
    add_column :fights, :battle_done, :boolean, default: false
  end
end
