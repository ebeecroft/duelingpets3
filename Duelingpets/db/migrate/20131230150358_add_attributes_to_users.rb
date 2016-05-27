class AddAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
    add_column :users, :remember_token, :string
    add_column :users, :admin, :boolean, default: false
    add_column :users, :maintenance, :boolean, default: false
  end
end
