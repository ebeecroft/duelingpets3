class Pet < ActiveRecord::Base
  attr_accessible :description, :species_name, :hp, :atk, :def, :spd, :monster, :image, :remote_image_url
  has_many :petowners, :foreign_key => "pet_id", :dependent => :destroy
  has_many :fights, :foreign_key => "pet_id", :dependent => :destroy
  belongs_to :user
  mount_uploader :image, ImageUploader
  validates :species_name, presence: true, uniqueness: { case_sensitive: false}
  validates :description, presence: true

  def to_param
     species_name
  end
end
