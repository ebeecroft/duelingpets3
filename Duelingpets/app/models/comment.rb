class Comment < ActiveRecord::Base
  attr_accessible :message
  #This is necessary for making the classes understandable
  belongs_to :from_user, :class_name => 'User', :foreign_key => 'from_user_id'
  belongs_to :to_user, :class_name => 'User', :foreign_key => 'user_id'
end
