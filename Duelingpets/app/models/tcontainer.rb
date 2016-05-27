class Tcontainer < ActiveRecord::Base
  attr_accessible :name
  belongs_to :forum
  belongs_to :user
  has_many :maintopics, :foreign_key => "tcontainer_id", :dependent => :destroy
end
