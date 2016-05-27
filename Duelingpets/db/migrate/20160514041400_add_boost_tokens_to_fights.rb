class AddBoostTokensToFights < ActiveRecord::Migration
  def change
    add_column :fights, :boost_tokens, :integer, default: 0
  end
end
