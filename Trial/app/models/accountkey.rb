class Accountkey < ActiveRecord::Base
  attr_accessible :activated, :token, :user_id
end
