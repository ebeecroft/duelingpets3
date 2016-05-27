class CreateNarratives < ActiveRecord::Migration
  def change
    create_table :narratives do |t|
      t.integer :subtopic_id
      t.integer :user_id
      t.text :story

      t.timestamps
    end
  end
end
