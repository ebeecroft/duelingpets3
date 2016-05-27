class CreateTcontainers < ActiveRecord::Migration
  def change
    create_table :tcontainers do |t|
      t.string :name
      t.integer :forum_id

      t.timestamps
    end
  end
end
