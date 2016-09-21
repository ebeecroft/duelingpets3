class Sound < ActiveRecord::Base
  attr_accessible :created_on, :description, :maintenance, :name, :reviewed, :subsheet_id, :user_id
end
