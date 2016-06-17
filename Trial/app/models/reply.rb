class Reply < ActiveRecord::Base
   attr_accessible :message
   belongs_to :user
   belongs_to :blog
   validates :message, presence: true
end
