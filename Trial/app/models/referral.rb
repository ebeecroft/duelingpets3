class Referral < ActiveRecord::Base
   belongs_to :referre, :class_name => 'User', :foreign_key => 'user_id'
   belongs_to :referrer, :class_name => 'User', :foreign_key => 'referred_by_id'
end
