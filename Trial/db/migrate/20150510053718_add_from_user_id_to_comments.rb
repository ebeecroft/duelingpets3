class AddFromUserIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :from_user_id, :integer
  end
end
