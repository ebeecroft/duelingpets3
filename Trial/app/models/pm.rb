class Pm < ActiveRecord::Base
  attr_accessible :created_on, :description, :from_user_id, :maintenance, :title, :user_id
end
