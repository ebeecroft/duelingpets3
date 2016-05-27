class AddStatsToPets < ActiveRecord::Migration
  def change
    add_column :pets, :level, :integer, default: 1
    add_column :pets, :hp, :integer, default: 1
    add_column :pets, :atk, :integer, default: 1
    add_column :pets, :def, :integer, default: 1
    add_column :pets, :spd, :integer, default: 1
    add_column :pets, :cost, :integer, default: 1
  end
end
