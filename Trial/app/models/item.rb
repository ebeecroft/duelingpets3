class Item < ActiveRecord::Base
  has_many :inventories, :foreign_key => "item_id", :dependent => :destroy
  belongs_to :user
  attr_accessible :description, :name, :hp, :atk, :def, :spd, :manyuses, :ipicture, :remote_ipicture_url
  mount_uploader :ipicture, IpictureUploader
  VALID_VALUE_REGEX = /\A[0-9]+\z/i
  validates :description, presence: true
  validates :name, presence: true, uniqueness: { case_sensitive: false}
  validates :hp, presence: true, format: { with: VALID_VALUE_REGEX}
  validates :atk, presence: true, format: { with: VALID_VALUE_REGEX}
  validates :def, presence: true, format: { with: VALID_VALUE_REGEX}
  validates :spd, presence: true, format: { with: VALID_VALUE_REGEX}

  def to_param # overridden
      name
  end
end
