class Maintopic < ActiveRecord::Base
   belongs_to :user
   has_many :subtopics, :foreign_key => "maintopic_id", :dependent => :destroy
   belongs_to :tcontainer
  attr_accessible :description, :topicname
end
