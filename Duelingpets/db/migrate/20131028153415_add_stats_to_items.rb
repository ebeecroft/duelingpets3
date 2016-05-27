class AddStatsToItems < ActiveRecord::Migration
  def change
    add_column :items, :hp, :integer
    add_column :items, :atk, :integer
    add_column :items, :def, :integer
    add_column :items, :spd, :integer
    add_column :items, :cost, :integer
  end
end
