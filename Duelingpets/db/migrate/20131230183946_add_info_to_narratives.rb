class AddInfoToNarratives < ActiveRecord::Migration
  def change
    add_column :narratives, :created_on, :datetime
    add_column :narratives, :maintenance, :boolean, default: false
  end
end
