class Preply < ActiveRecord::Base
   attr_accessible :message
   belongs_to :user
   belongs_to :pm
   validates :message, presence: true
end
