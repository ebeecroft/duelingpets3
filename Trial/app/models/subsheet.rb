class Subsheet < ActiveRecord::Base
  attr_accessible :collab_mode, :created_on, :description, :mainsheet_id, :maintenance, :name, :user_id
end
