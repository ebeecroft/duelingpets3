class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.bigint :id
      t.varchar :name
      t.longblob :image
      t.varchar :description
      t.int :hp
      t.int :atk
      t.int :def
      t.int :spd
      t.int :cost
      t.tinyint :equip_flag
      t.varchar :type
      t.date :created_at
      t.tinyint :maintenance

      t.timestamps
    end
  end
end
