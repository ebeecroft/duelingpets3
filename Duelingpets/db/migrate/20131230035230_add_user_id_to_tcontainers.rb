class AddUserIdToTcontainers < ActiveRecord::Migration
  def change
    add_column :tcontainers, :user_id, :integer
  end
end
