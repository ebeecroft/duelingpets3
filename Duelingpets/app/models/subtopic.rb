class Subtopic < ActiveRecord::Base
   belongs_to :maintopic
   belongs_to :user
   has_many :narratives, :foreign_key => "subtopic_id", :dependent => :destroy
   attr_accessible :description, :topicname
end
