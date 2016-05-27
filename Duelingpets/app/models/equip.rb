class Equip < ActiveRecord::Base
  belongs_to :petowner
  belongs_to :inventory

  validates :inventory_id, presence: true, uniqueness: { :scope =>[:petowner_id]}
  validates :petowner_id, presence: true #, uniqueness: { :scope =>[:inventory_id] }
#  validates :pet_name, presence: true, uniqueness: { case_sensitive: false, :scope =>[:user_id, :pet_id]} #current setting applies to just a
end
