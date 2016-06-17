class Reply < ActiveRecord::Base
  attr_accessible :blog_id, :created_on, :maintenance, :message, :user_id
end
