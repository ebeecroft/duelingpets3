class RemoveEmailFromSuggestions < ActiveRecord::Migration
  def change
    remove_column :suggestions, :email
  end
end
