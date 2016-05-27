class CreateMaintopics < ActiveRecord::Migration
  def change
    create_table :maintopics do |t|
      t.integer :user_id
      t.string :topicname
      t.text :description

      t.timestamps
    end
  end
end
