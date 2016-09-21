class Mainsheet < ActiveRecord::Base
  attr_accessible :created_on, :description, :maintenance, :name, :user_id
end
