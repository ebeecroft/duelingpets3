class Onlineuser < ActiveRecord::Base
  attr_accessible :last_visited, :signed_in_at, :signed_out_at, :user_id
end
