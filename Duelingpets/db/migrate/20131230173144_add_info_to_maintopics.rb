class AddInfoToMaintopics < ActiveRecord::Migration
  def change
    add_column :maintopics, :created_on, :datetime
    add_column :maintopics, :maintenance, :boolean, default: false
    add_column :maintopics, :tcontainer_id, :integer
  end
end
