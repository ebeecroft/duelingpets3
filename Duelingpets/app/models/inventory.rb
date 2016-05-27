class Inventory < ActiveRecord::Base
   belongs_to :item
   belongs_to :user
   has_one :equip, :foreign_key => "inventory_id", :dependent => :destroy

   validates :user_id, presence: true
   validates :item_id, presence: true
end
