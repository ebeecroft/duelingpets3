class AddQtyToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :qty, :integer, default: 0
  end
end
