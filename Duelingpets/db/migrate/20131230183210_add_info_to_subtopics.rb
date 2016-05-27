class AddInfoToSubtopics < ActiveRecord::Migration
  def change
    add_column :subtopics, :created_on, :datetime
    add_column :subtopics, :maintenance, :boolean, default: false
  end
end
