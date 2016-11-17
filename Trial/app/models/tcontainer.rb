class Tcontainer < ActiveRecord::Base
   attr_accessible :name
   belongs_to :forum
   belongs_to :user
   has_many :maintopics, :foreign_key => "tcontainer_id", :dependent => :destroy
   VALID_NAME = /\A[A-Za-z][A-Za-z][A-Za-z0-9 ]+\z/
   validates :name, presence: true, format: {with: VALID_NAME, case_sensitive: false}
end
