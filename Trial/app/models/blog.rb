class Blog < ActiveRecord::Base
  attr_accessible :created_on, :description, :maintenance, :title, :user_id
end
