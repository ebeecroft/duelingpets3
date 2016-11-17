class Petowner < ActiveRecord::Base
  attr_accessible :pet_name, :pet_id
  belongs_to :pet
  belongs_to :user
  has_many :equips, :foreign_key => "petowner_id", :dependent => :destroy
  has_many :fights, :foreign_key => "petowner_id", :dependent => :destroy
  VALID_NAME = /\A[A-Za-z][A-Za-z][A-Za-z0-9 ]+\z/
  validates :pet_name, presence: true, format: {with: VALID_NAME}, uniqueness: { case_sensitive: false, :scope =>[:user_id, :pet_id]} #current setting applies to just a pet_id and not a user.
end
