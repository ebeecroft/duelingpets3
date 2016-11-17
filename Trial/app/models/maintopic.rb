class Maintopic < ActiveRecord::Base
   attr_accessible :description, :topicname
   belongs_to :user
   has_many :subtopics, :foreign_key => "maintopic_id", :dependent => :destroy
   belongs_to :tcontainer
   VALID_NAME = /\A[A-Za-z][A-Za-z][A-Za-z0-9 ]+\z/
   validates :description, presence: true
   validates :topicname, presence: true, format: {with: VALID_NAME, case_sensitive: false}
end
