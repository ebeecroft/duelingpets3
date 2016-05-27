class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.datetime :created_on

      t.timestamps
    end
  end
end
