class AddInfoToItems < ActiveRecord::Migration
  def change
    add_column :items, :ipicture, :string
    add_column :items, :type, :string
    add_column :items, :manyuses, :boolean, default: false
    add_column :items, :maintenance, :boolean, default: false
  end
end
