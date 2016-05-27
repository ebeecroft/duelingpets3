class Item < ActiveRecord::Base
#   has_many :attendances, :foreign_key => "groupee_id", :dependent => :destroy
   has_many :inventories, :foreign_key => "item_id", :dependent => :destroy
  attr_accessible :description, :name, :hp, :atk, :def, :spd, :cost, :manyuses, :ipicture, :remote_ipicture_url
  mount_uploader :ipicture, IpictureUploader
  validates :description, presence: true
  validates :name, presence: true, uniqueness: { case_sensitive: false}

  def to_param # overridden
      name
  end
end
