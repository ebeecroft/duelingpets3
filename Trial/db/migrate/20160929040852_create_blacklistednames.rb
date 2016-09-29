class CreateBlacklistednames < ActiveRecord::Migration
  def change
    create_table :blacklistednames do |t|
      t.string :name

      t.timestamps
    end
  end
end
