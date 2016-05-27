class Petowner < ActiveRecord::Base
  attr_accessible :pet_name, :pet_id
  belongs_to :pet
  belongs_to :user
  has_many :equips, :foreign_key => "petowner_id", :dependent => :destroy
  has_many :fights, :foreign_key => "petowner_id", :dependent => :destroy
  validates :pet_name, presence: true, uniqueness: { case_sensitive: false, :scope =>[:user_id, :pet_id]} #current setting applies to just a pet_id and not a user.
end
