class AddBoostTokensToPetowners < ActiveRecord::Migration
  def change
    add_column :petowners, :boost_tokens, :integer, default: 0
  end
end
