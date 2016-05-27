class AddArtToArtworks < ActiveRecord::Migration
  def change
    add_column :artworks, :art, :string
  end
end
