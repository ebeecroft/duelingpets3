class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user
      t.string :author
      t.text :message

      t.timestamps
    end
  end
end
