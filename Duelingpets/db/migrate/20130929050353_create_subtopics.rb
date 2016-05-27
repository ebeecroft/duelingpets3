class CreateSubtopics < ActiveRecord::Migration
  def change
    create_table :subtopics do |t|
      t.integer :maintopic_id
      t.integer :user_id
      t.string :topicname
      t.text :description

      t.timestamps
    end
  end
end
