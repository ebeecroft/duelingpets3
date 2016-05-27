class AddExpGainedToFights < ActiveRecord::Migration
  def change
    add_column :fights, :exp_gained, :integer, default: 0
  end
end
