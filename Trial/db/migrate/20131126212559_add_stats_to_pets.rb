class AddStatsToPets < ActiveRecord::Migration
  def change
    add_column :pets, :level, :integer
    add_column :pets, :hp, :integer
    add_column :pets, :atk, :integer
    add_column :pets, :def, :integer
    add_column :pets, :spd, :integer
    add_column :pets, :cost, :integer
  end
end
