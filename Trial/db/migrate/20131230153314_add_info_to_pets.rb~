class AddInfoToPets < ActiveRecord::Migration
  def change
    add_column :pets, :image, :string
    add_column :pets, :monster, :boolean, default: false
    add_column :pets, :created_by, :string
    add_column :pets, :reviewed, :boolean, default: false
  end
end
