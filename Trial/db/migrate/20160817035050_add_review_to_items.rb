class AddReviewToItems < ActiveRecord::Migration
  def change
    add_column :items, :user_id, :integer
    add_column :items, :reviewed, :boolean, default: false
  end
end
