class Preply < ActiveRecord::Base
  attr_accessible :created_on, :maintenance, :message, :pm_id, :user_id
end
