class Referral < ActiveRecord::Base
  attr_accessible :created_on, :referred_by_id, :user_id
end
