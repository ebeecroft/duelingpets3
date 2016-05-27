class Usertype < ActiveRecord::Base
  attr_accessible :privilege, :user_id #Only priviledge will be changeable
  belongs_to :user
end
