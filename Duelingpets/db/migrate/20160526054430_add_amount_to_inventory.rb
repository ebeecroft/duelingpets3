class AddAmountToInventory < ActiveRecord::Migration
  def change
    add_column :inventories, :amount, :integer
  end
end
