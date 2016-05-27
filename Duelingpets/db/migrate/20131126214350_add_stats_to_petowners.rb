class AddStatsToPetowners < ActiveRecord::Migration
  def change
    add_column :petowners, :level, :integer
    add_column :petowners, :hp, :integer
    add_column :petowners, :atk, :integer
    add_column :petowners, :def, :integer
    add_column :petowners, :spd, :integer
    add_column :petowners, :exp, :integer, default: 0
    add_column :petowners, :hp_max, :integer
    add_column :petowners, :in_battle, :boolean, default: false
  end
end
