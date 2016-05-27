class AddInfoToComments < ActiveRecord::Migration
  def change
    add_column :comments, :created_on, :datetime
    add_column :comments, :maintenance, :boolean, default: false
  end
end
