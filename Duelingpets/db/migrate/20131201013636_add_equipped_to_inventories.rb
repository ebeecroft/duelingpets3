class AddEquippedToInventories < ActiveRecord::Migration
  def change
    add_column :inventories, :equipped, :boolean, default: false
  end
end
