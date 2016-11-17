class Pet < ActiveRecord::Base
  attr_accessible :description, :species_name, :hp, :atk, :def, :spd, :monster, :image, :remote_image_url, :image_cache
  has_many :petowners, :foreign_key => "pet_id", :dependent => :destroy
  has_many :fights, :foreign_key => "pet_id", :dependent => :destroy
  belongs_to :user
  mount_uploader :image, ImageUploader
  VALID_NAME = /\A[A-Za-z][A-Za-z][A-Za-z0-9 ]+\z/
  validates :species_name, presence: true, format: {with: VALID_NAME}, uniqueness: { case_sensitive: false}
  validates :description, presence: true

  def to_param
     species_name
  end
end
