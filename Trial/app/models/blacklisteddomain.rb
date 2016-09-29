class Blacklisteddomain < ActiveRecord::Base
  attr_accessible :domain_only, :name
end
