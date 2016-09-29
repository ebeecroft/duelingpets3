class CreateBlacklisteddomains < ActiveRecord::Migration
  def change
    create_table :blacklisteddomains do |t|
      t.string :name
      t.boolean :domain_only, default: false

      t.timestamps
    end
  end
end
