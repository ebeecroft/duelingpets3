class CreateGchapters < ActiveRecord::Migration
  def change
    create_table :gchapters do |t|
      t.string :title
      t.datetime :created_on

      t.timestamps
    end
  end
end
