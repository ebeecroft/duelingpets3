class Subtopic < ActiveRecord::Base
   attr_accessible :description, :topicname
   belongs_to :maintopic
   belongs_to :user
   has_many :narratives, :foreign_key => "subtopic_id", :dependent => :destroy
   VALID_NAME = /\A[A-Za-z][A-Za-z][A-Za-z0-9 ]+\z/
   validates :description, presence: true
   validates :topicname, presence: true, format: {with: VALID_NAME, case_sensitive: false}
end
