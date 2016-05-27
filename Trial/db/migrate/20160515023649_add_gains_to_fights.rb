class AddGainsToFights < ActiveRecord::Migration
  def change
    add_column :fights, :exp_gained, :integer, default: 0
    add_column :fights, :boost_tokens, :integer, default: 0
  end
end
