class Item < ActiveRecord::Base
  has_many :inventories, :foreign_key => "item_id", :dependent => :destroy
  belongs_to :user
  attr_accessible :description, :name, :hp, :atk, :def, :spd, :manyuses, :ipicture, :remote_ipicture_url
  mount_uploader :ipicture, IpictureUploader
  validates :description, presence: true
  validates :name, presence: true, uniqueness: { case_sensitive: false}

  def to_param # overridden
      name
  end
end
