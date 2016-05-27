class Narrative < ActiveRecord::Base
   belongs_to :subtopic
   belongs_to :user
   attr_accessible :story
end
